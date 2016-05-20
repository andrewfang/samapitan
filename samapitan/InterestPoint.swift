//
//  InterestPoint.swift
//  samapitan
//
//  Created by Andrew Fang on 5/18/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit
import MapKit

class InterestPoint: NSObject, MKAnnotation {
    
    var titleString:String!
    var descriptionString: String!
    var coord:CLLocationCoordinate2D!
    var photo: UIImage!
    
    init(coord:CLLocationCoordinate2D, title:String, description:String, photoUrl:String) {
        super.init()
        self.coord = coord
        self.titleString = title
        self.descriptionString = description
        if let url = NSURL(string: photoUrl) {
            if let data = NSData(contentsOfURL: url) {
                self.photo = UIImage(data: data)
            } else {
                photo = UIImage(named: "placeholder")
            }
        } else {
            photo = UIImage(named: "placeholder")
        }
    }
    
    init(coord:CLLocationCoordinate2D, title:String, description:String, photo:UIImage) {
        super.init()
        self.coord = coord
        self.titleString = title
        self.descriptionString = description
        self.photo = photo
    }
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coord = coordinate
        super.init()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return self.coord
    }
    
    var title: String? {
        return self.titleString
    }
    
    var subtitle: String? {
        return ""
    }
}
