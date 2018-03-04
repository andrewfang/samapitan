//
//  ViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/10/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private struct Constants {
        static let PostPin = "PostPin"
        static let PersonPin = "PersonPin"
        static let InterestPin = "InterestPin"
        static let ShowProfileSegue = "ShowProfileSegue"
        static let ShowRequestSegue = "ShowRequestSegue"
        static let ShowInterestSegue = "ShowInterestSegue"
        static let ThumbnailFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
    }

    @IBOutlet weak var mapView:MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }

    var locationManager:CLLocationManager!
    var posts:[HelpPost]!
    var people:[PeoplePost]!
    var interestPoints:[InterestPoint]!
    var firstLoad:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Samapitan"
        self.navigationController?.navigationBar.barTintColor = UIColor.appTabBarColor()
        self.navigationController?.navigationBar.isTranslucent = false
        Database.loadPeopleData {
            self.people = Database.PeoplePinsToLoad
            self.addPeople()
        }
        
        Database.loadRequestData {
            self.posts = []
            self.posts.append(contentsOf: Database.AllRequests)
            self.posts.append(contentsOf: Database.PendingRequests)
            self.posts.append(contentsOf: Database.RespondedToRequests)
            self.addRequest()
        }
        
        Database.loadInterestData {
            self.interestPoints = Database.InterestPoints
            self.addInterest()
        }
        
        if (!UserDefaults.standard.bool(forKey: "onboarded")) {
            self.performSegue(withIdentifier: "showOnboarding", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if UserDefaults.standard.bool(forKey: "onboarded") {
            self.setupLocationManager()
        }
        
        self.mapView.view(for: mapView.userLocation)?.isHidden = !UserDefaults.standard.bool(forKey: "available")
        self.updateAnnotations()
    }
    
    private func addPeople() {
        self.mapView?.addAnnotations(self.people)
    }
    
    private func addRequest() {
        self.mapView?.addAnnotations(self.posts)
    }
    
    private func addInterest() {
        self.mapView?.addAnnotations(self.interestPoints)
    }
    
    private func updateAnnotations() {
        
        if self.posts != nil {
            self.mapView?.removeAnnotations(self.posts)
            self.mapView?.removeAnnotations(self.interestPoints)
            
            self.posts = []
            self.posts.append(contentsOf: Database.AllRequests)
            self.posts.append(contentsOf: Database.PendingRequests)
            self.posts.append(contentsOf: Database.RespondedToRequests)
            self.mapView?.addAnnotations(self.posts)
            
            
            self.interestPoints = Database.InterestPoints
            self.mapView?.addAnnotations(self.interestPoints)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        self.mapView.view(for: mapView.userLocation)?.isHidden = !UserDefaults.standard.bool(forKey: "available")
        if let _ = annotation as? MKUserLocation {
            return nil
        }
        
        var view: MKAnnotationView!
        if let _ = annotation as? HelpPost {
            view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.PostPin)
            if (view == nil) {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.PostPin)
            }
                view.canShowCallout = true
                if let hp = annotation as? HelpPost {
                    if (hp.type == .MyPending) {
                        view.isDraggable = true
                    } else {
                        view.isDraggable = false
                    }
                    switch (hp.urgency) {
                    case HelpPost.Urgency.Urgent:
                        view.image = UIImage(named: "helpred")
                    case HelpPost.Urgency.NotUrgent:
                        view.image = UIImage(named: "helpgreen")
                }
                view.leftCalloutAccessoryView = nil
                    view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                view.annotation = annotation
                if let hp = annotation as? HelpPost {
                    if (hp.type == .MyPending) {
                        view.isDraggable = true
                    } else {
                        view.isDraggable = false
                    }
                    switch (hp.urgency) {
                    case HelpPost.Urgency.Urgent:
                        view.image = UIImage(named: "helpred")
                    case HelpPost.Urgency.NotUrgent:
                        view.image = UIImage(named: "helpgreen")
                    }
                }
            }
        } else if let _ = annotation as? PeoplePost {
            view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.PersonPin)
            if (view == nil) {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.PersonPin)
                view.canShowCallout = true
                view.image = UIImage(named: "personpin")
                view.calloutOffset = CGPoint.zero
                view.rightCalloutAccessoryView = nil
                view.leftCalloutAccessoryView = UIButton(frame: Constants.ThumbnailFrame)
            } else {
                view.annotation = annotation
                view.image = UIImage(named: "personpin")
            }
        } else if let _ = annotation as? InterestPoint {
            view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.InterestPin)
            if (view == nil) {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.InterestPin)
                view.canShowCallout = true
                view.image = UIImage(named: "interestPoint")
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                view.calloutOffset = CGPoint.zero
                view.leftCalloutAccessoryView = nil
            } else {
                view.annotation = annotation
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let thumbnailImageView = view.leftCalloutAccessoryView as? UIButton,
            let anno = view.annotation as? PeoplePost {
            if let url = NSURL(string: anno.imageURL) {
                if let data = try? Data(contentsOf: url as URL) {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            thumbnailImageView.setImage(image, for: .normal)
                            thumbnailImageView.imageView?.contentMode = .scaleAspectFill
                        }
                    }
                }
            }
        }
        
        if let thumbnailButton = view.rightCalloutAccessoryView as? UIButton {
            thumbnailButton.tintColor = UIColor.appBlue()
            if let hp = view.annotation as? HelpPost, hp.urgency == .Urgent {
                thumbnailButton.tintColor = UIColor.appRed()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch (newState) {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default:
            break
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            performSegue(withIdentifier: Constants.ShowProfileSegue, sender: view)
        } else if control == view.rightCalloutAccessoryView {
            if let _ = view.annotation as? HelpPost {
                performSegue(withIdentifier: Constants.ShowRequestSegue, sender: view)
            } else if let _ = view.annotation as? InterestPoint {
                performSegue(withIdentifier: Constants.ShowInterestSegue, sender: view)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.ShowProfileSegue {
            if let view = sender as? MKAnnotationView {
                if let ppost = view.annotation as? PeoplePost {
                    if let destVC = segue.destination as? ProfileViewController {
                        destVC.person = ppost
                    }
                }
            }
        } else if segue.identifier == Constants.ShowRequestSegue {
            if let view = sender as? MKAnnotationView {
                if let hpost = view.annotation as? HelpPost {
                    if let destVC = segue.destination as? RequestViewController {
                        destVC.helpPost = hpost
                    }
                }
            }
        } else if segue.identifier == Constants.ShowInterestSegue {
            if let view = sender as? MKAnnotationView {
                if let ipost = view.annotation as? InterestPoint {
                    if let destVC = segue.destination as? InterestViewController {
                        destVC.interestPoint = ipost
                    }
                }
            }
        }
    }

    // MARK: - Location stuff
    
    func setupLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager?.distanceFilter = 5
        self.locationManager?.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager?.stopUpdatingLocation()
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationObj = locations.last {
            print(locationObj.coordinate)
            UserDefaults.standard.set(locationObj.coordinate.latitude, forKey: "lat")
            UserDefaults.standard.set(locationObj.coordinate.longitude, forKey: "long")
            UserDefaults.standard.set(true, forKey: "available")
            if (firstLoad) {
                firstLoad = false
                self.mapView.setCenter(locationObj.coordinate, animated: true)
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: locationObj.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    
}

