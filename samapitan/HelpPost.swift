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
    enum Urgency: Int {
        case NotUrgent = 0
        case Urgent = 1
    }
    
    enum RequestType {
        case MyPending
        case MyResponded
        case Other
    }
    
    var titleString:String!
    var subtitleString:String!
    var descriptionString: String!
    var coord:CLLocationCoordinate2D!
    var urgency: Urgency
    var color: UIColor!
    var membersHelpingOut:[PeoplePost]!
    var type:RequestType
    var timePosted: String!

    init(coord:CLLocationCoordinate2D, title:String, description:String, urgency:Urgency, type:RequestType, timePosted:String, membersHelpingOut:[PeoplePost]) {
        self.coord = coord
        self.titleString = title
        self.subtitleString = ""
        self.urgency = urgency
        self.type = type
        self.timePosted = timePosted
        self.descriptionString = description
        switch (urgency) {
        case .NotUrgent:
            self.color = UIColor.appBlue()
        case .Urgent:
            self.color = UIColor.appRed()
        }
        
        self.membersHelpingOut = membersHelpingOut
        
    }

    @objc var coordinate: CLLocationCoordinate2D {
        return self.coord
    }
    
    @objc var title: String? {
        return self.titleString
    }
    
    @objc var subtitle: String? {
        return self.subtitleString
    }
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
}
