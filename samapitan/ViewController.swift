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
        self.navigationController?.navigationBar.translucent = false
        self.setupLocationManager()
        Database.loadPeopleData({
            self.people = Database.PeoplePinsToLoad
            self.addPeople()
        })
        
        Database.loadRequestData({
            self.posts = []
            self.posts.appendContentsOf(Database.AllRequests)
            self.posts.appendContentsOf(Database.PendingRequests)
            self.posts.appendContentsOf(Database.RespondedToRequests)
            self.addRequest()
        })
        
        Database.loadInterestData({
            self.interestPoints = Database.InterestPoints
            self.addInterest()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
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
            self.posts.appendContentsOf(Database.AllRequests)
            self.posts.appendContentsOf(Database.PendingRequests)
            self.posts.appendContentsOf(Database.RespondedToRequests)
            self.mapView?.addAnnotations(self.posts)
            
            
            self.interestPoints = Database.InterestPoints
            self.mapView?.addAnnotations(self.interestPoints)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? MKUserLocation {
            return nil
        }
        
        var view: MKAnnotationView!
        if let _ = annotation as? HelpPost {
            view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.PostPin)
            if (view == nil) {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.PostPin)
            }
                view.canShowCallout = true
                if let hp = annotation as? HelpPost {
                    if (hp.type == .MyPending) {
                        view.draggable = true
                    } else {
                        view.draggable = false
                    }
                    switch (hp.urgency) {
                    case HelpPost.Urgency.Urgent:
                        view.image = UIImage(named: "helpred")
                    case HelpPost.Urgency.NotUrgent:
                        view.image = UIImage(named: "helpgreen")
                }
                view.leftCalloutAccessoryView = nil
                view.rightCalloutAccessoryView = UIButton(frame: Constants.ThumbnailFrame)
            } else {
                view.annotation = annotation
                if let hp = annotation as? HelpPost {
                    if (hp.type == .MyPending) {
                        view.draggable = true
                    } else {
                        view.draggable = false
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
            view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.PersonPin)
            if (view == nil) {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.PersonPin)
                view.canShowCallout = true
                view.image = UIImage(named: "personpin")
                view.calloutOffset = CGPointMake(0, 0)
                view.rightCalloutAccessoryView = nil
                view.leftCalloutAccessoryView = UIButton(frame: Constants.ThumbnailFrame)
            } else {
                view.annotation = annotation
                view.image = UIImage(named: "personpin")
            }
        } else if let _ = annotation as? InterestPoint {
            view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.InterestPin)
            if (view == nil) {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.InterestPin)
                view.canShowCallout = true
                view.image = UIImage(named: "interestPoint")
                view.calloutOffset = CGPointMake(0, 0)
                view.rightCalloutAccessoryView = UIButton(frame: Constants.ThumbnailFrame)
                view.leftCalloutAccessoryView = nil
            } else {
                view.annotation = annotation
                view.image = UIImage(named: "interestPoint")
            }
        }
        return view
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let thumbnailImageView = view.leftCalloutAccessoryView as? UIButton,
            let anno = view.annotation as? PeoplePost {
            if let url = NSURL(string: anno.imageURL) {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
                    if let data = NSData(contentsOfURL: url) {
                        dispatch_async(dispatch_get_main_queue()){
                            if let image = UIImage(data: data) {
                                thumbnailImageView.setImage(image, forState: .Normal)
                            }
                        }
                    }
                }
            }
        }
        
        if let thumbnailImageView = view.rightCalloutAccessoryView as? UIButton {
            if let hp = view.annotation as? HelpPost {
                switch (hp.urgency) {
                case .Urgent:
                    thumbnailImageView.setImage(UIImage(named: "blockRed"), forState: .Normal)
                case .NotUrgent:
                    thumbnailImageView.setImage(UIImage(named: "blockGreen"), forState: .Normal)
                default:
                    break
                }
                
            } else if let ipoint = view.annotation as? InterestPoint {
                thumbnailImageView.setImage(ipoint.photo, forState: .Normal)
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch (newState) {
        case .Starting:
            view.dragState = .Dragging
        case .Ending, .Canceling:
            view.dragState = .None
        default:
            break
        }
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            performSegueWithIdentifier(Constants.ShowProfileSegue, sender: view)
        } else if control == view.rightCalloutAccessoryView {
            if let _ = view.annotation as? HelpPost {
                performSegueWithIdentifier(Constants.ShowRequestSegue, sender: view)
            } else if let _ = view.annotation as? InterestPoint {
                performSegueWithIdentifier(Constants.ShowInterestSegue, sender: view)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.ShowProfileSegue {
            if let view = sender as? MKAnnotationView {
                if let ppost = view.annotation as? PeoplePost {
                    if let destVC = segue.destinationViewController as? ProfileViewController {
                        destVC.person = ppost
                    }
                }
            }
        } else if segue.identifier == Constants.ShowRequestSegue {
            if let view = sender as? MKAnnotationView {
                if let hpost = view.annotation as? HelpPost {
                    if let destVC = segue.destinationViewController as? RequestViewController {
                        destVC.helpPost = hpost
                    }
                }
            }
        } else if segue.identifier == Constants.ShowInterestSegue {
            if let view = sender as? MKAnnotationView {
                if let ipost = view.annotation as? InterestPoint {
                    if let destVC = segue.destinationViewController as? InterestViewController {
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
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.locationManager?.stopUpdatingLocation()
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationObj = locations.last {
            print(locationObj.coordinate)
            NSUserDefaults.standardUserDefaults().setDouble(locationObj.coordinate.latitude, forKey: "lat")
            NSUserDefaults.standardUserDefaults().setDouble(locationObj.coordinate.longitude, forKey: "long")
            if (firstLoad) {
                firstLoad = false
                self.mapView.setCenterCoordinate(locationObj.coordinate, animated: true)
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: locationObj.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    
}

