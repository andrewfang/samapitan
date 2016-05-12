//
//  PeoplePost.swift
//  samapitan
//
//  Created by Andrew Fang on 5/10/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit
import MapKit

class PeoplePost: NSObject, MKAnnotation {
    
    var name:String!
    var group:String!
    var coord:CLLocationCoordinate2D!
    var imageURL: String!
    var bio: String!
    
    init(coord:CLLocationCoordinate2D, name:String, group:String, imageURL:String, bio:String) {
        self.coord = coord
        self.name = name
        self.group = group
        self.imageURL = imageURL
        self.bio = bio
    }
    
    @objc var coordinate: CLLocationCoordinate2D {
        return self.coord
    }
    
    @objc var title: String? {
        return self.name
    }
    
    @objc var subtitle: String? {
        return self.group
    }
}
