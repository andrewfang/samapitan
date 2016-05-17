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
        static let ShowProfileSegue = "ShowProfileSegue"
        static let ShowRequestSegue = "ShowRequestSegue"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Samapitan"
        self.navigationController?.navigationBar.barTintColor = UIColor.appTabBarColor()
        self.navigationController?.navigationBar.translucent = true
        self.setupLocationManager()
        self.posts = []
        self.posts.appendContentsOf(Database.AllRequests)
        self.posts.appendContentsOf(Database.PendingRequests)
        self.posts.appendContentsOf(Database.RespondedToRequests)
        self.people = Database.PeoplePinsToLoad
        self.addAnnotations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    private func addAnnotations() {
        self.mapView?.addAnnotations(self.posts)
        self.mapView?.showAnnotations(self.posts, animated: true)
        
        self.mapView?.addAnnotations(self.people)
        self.mapView?.showAnnotations(self.people, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? MKUserLocation {
            return nil
        }
        
        var view: MKAnnotationView!
        if let _ = annotation as? HelpPost {
            view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.PostPin)
            if (view == nil) {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.PostPin)
                view.canShowCallout = true
                if let a = view as? MKPinAnnotationView,
                    let hp = annotation as? HelpPost {
                    a.pinTintColor = hp.color
                }
                view.leftCalloutAccessoryView = nil
                view.rightCalloutAccessoryView = UIButton(frame: Constants.ThumbnailFrame)
            } else {
                view.annotation = annotation
            }
        } else {
            view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.PersonPin)
            if (view == nil) {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.PersonPin)
                view.canShowCallout = true
                view.image = UIImage(named: "personPin")
                view.calloutOffset = CGPointMake(0, 0)
                view.rightCalloutAccessoryView = nil
                view.leftCalloutAccessoryView = UIButton(frame: Constants.ThumbnailFrame)
            } else {
                view.annotation = annotation
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
        
        if let thumbnailImageView = view.rightCalloutAccessoryView as? UIButton,
            let _ = view.annotation as? HelpPost {
            thumbnailImageView.setImage(UIImage(named: "help"), forState: .Normal)
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            performSegueWithIdentifier(Constants.ShowProfileSegue, sender: view)
        } else if control == view.rightCalloutAccessoryView {
            performSegueWithIdentifier(Constants.ShowRequestSegue, sender: view)
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
            self.mapView.setCenterCoordinate(locationObj.coordinate, animated: true)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: locationObj.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
            
        }
    }
    
    
}

