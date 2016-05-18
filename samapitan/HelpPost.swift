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
        case Later = 0
        case ASAP = 1
        case Immediately = 2
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
    var urgency: Urgency!
    var color: UIColor!
    var membersHelpingOut:[PeoplePost]!
    var type:RequestType

    init(coord:CLLocationCoordinate2D, title:String, description:String, urgency:Urgency, type:RequestType, membersHelpingOut:[PeoplePost]) {
        self.coord = coord
        self.titleString = title
        self.subtitleString = ""
        self.urgency = urgency
        self.type = type
        self.descriptionString = description
        switch (urgency) {
        case .ASAP:
            self.color = UIColor.appOrange()
        case .Later:
            self.color = UIColor.greenColor()
        case .Immediately:
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
}
