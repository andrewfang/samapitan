//
//  HelpPost.swift
//  samapitan
//
//  Created by Andrew Fang on 5/10/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit
import MapKit

class HelpPost: NSObject, MKAnnotation {
    
    var titleString:String!
    var subtitleString:String!
    var coord:CLLocationCoordinate2D!
    var color: UIColor!

    init(coord:CLLocationCoordinate2D, title:String, subtitle:String, color:UIColor) {
        self.coord = coord
        self.titleString = title
        self.subtitleString = subtitle
        self.color = color
    }

    @objc var coordinate: CLLocationCoordinate2D {
//        let lat = self.latlong.coordinate.latitude + Double(arc4random())/Double(UINT32_MAX)/10000.0
//        let long = self.latlong.coordinate.longitude + Double(arc4random())/Double(UINT32_MAX)/10000.0
        return self.coord
    }
    
    @objc var title: String? {
        return self.titleString
    }
    
    @objc var subtitle: String? {
        return self.subtitleString
    }
}
