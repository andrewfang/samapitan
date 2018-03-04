//
//  Database.swift
//  samapitan
//
//  Created by Andrew Fang on 5/16/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase

class Database {
    
    enum ChatOwner {
        case Me
        case NotMe
        case Joined
    }
    struct ChatMessage {
        var textBody: String
        var owner: ChatOwner
        var ownerName: String
        
        init(textBody:String, owner:ChatOwner, ownerName:String) {
            self.textBody = textBody
            self.owner = owner
            self.ownerName = ownerName
        }
    }
    
    static func loadPeopleData(callback: @escaping () -> Void) {
        let firebase = FIRDatabase.database().reference()
        firebase.child("people").observeSingleEvent(of: .value, with: { (snapshot) in
            if let people = snapshot.value as? [[String: AnyObject]] {
                for person in people {
                    let name = person["name"] as! String
                    let bio = person["bio"] as! String
                    let imageUrl = person["imageUrl"] as! String
                    let group = person["group"] as! String
                    let lat = person["lat"] as! Double
                    let long = person["long"] as! Double
                    PeoplePinsToLoad.append(PeoplePost(coord: CLLocationCoordinate2D(latitude: lat, longitude: long), name: name, group: group, imageURL: imageUrl, bio: bio))
                }
                callback()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func loadInterestData(callback: @escaping () -> Void) {
        let firebase = FIRDatabase.database().reference()
        firebase.child("interests").observeSingleEvent(of: .value, with: { (snapshot) in
            if let interests = snapshot.value as? [[String: AnyObject]] {
                for interest in interests {
                    let title = interest["title"] as! String
                    let description = interest["description"] as! String
                    let photoUrl = interest["photoUrl"] as! String
                    let lat = interest["lat"] as! Double
                    let long = interest["long"] as! Double
                    InterestPoints.append(InterestPoint(coord: CLLocationCoordinate2D(latitude: lat, longitude: long), title: title, description: description, photoUrl: photoUrl))
                }
                callback()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func loadRequestData(callback: @escaping () -> Void) {
        let firebase = FIRDatabase.database().reference()
        firebase.child("requests").observeSingleEvent(of: .value, with: { (snapshot) in
            if let requests = snapshot.value as? [[String: AnyObject]] {
                for request in requests {
                    let title = request["title"] as! String
                    let description = request["description"] as! String
                    let lat = request["lat"] as! Double
                    let long = request["long"] as! Double
                    let urg = request["urgency"] as! Int
                    let time = request["time"] as! String
                    let chats = request["chat"] as! [[String:String]]
                    
                    let urgency = urg == 0 ? HelpPost.Urgency.NotUrgent : HelpPost.Urgency.Urgent
                    
                    let members = request["members"] as! [[String: AnyObject]]
                    var membersHelpingOut:[PeoplePost] = []
                    for member in members {
                        membersHelpingOut.append(PeoplePost(coord: CLLocationCoordinate2D(latitude: 0, longitude: 0), name: member["name"] as! String, group: member["group"] as! String, imageURL: member["imageUrl"] as! String, bio: ""))
                    }
                    
                    self.AllRequests.append(HelpPost(coord: CLLocationCoordinate2D(latitude: lat, longitude: long), title: title, description: description, urgency: urgency, type: HelpPost.RequestType.Other, timePosted: time, membersHelpingOut: membersHelpingOut))
                    
                    Chats[title] = []
                    var owner:Database.ChatOwner
                    for chat in chats {
                        switch chat["owner"]! {
                        case "NotMe":
                            owner = .NotMe
                        case "Me":
                            owner = .Me
                        case "Joined":
                            owner = .Joined
                        default:
                            owner = .NotMe
                        }
                        Chats[title]?.append(ChatMessage(textBody: chat["text"]!, owner: owner, ownerName: chat["ownerName"]!))
                    }
                }
                callback()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static var PeoplePinsToLoad:[PeoplePost] = []
    
    static var InterestPoints:[InterestPoint] = []
    
    static var AllRequests:[HelpPost] = []
    
    static var PendingRequests:[HelpPost] = []
    
    static var RespondedToRequests:[HelpPost] = []
    
    static var Chats:[String:[ChatMessage]] = [:]
    
    static func respondToRequest(request:HelpPost) {
        var idxToRemove:Int?
        for (i, theRequest) in Database.AllRequests.enumerated() {
            if (theRequest.titleString == request.titleString) {
                idxToRemove = i
                break
            }
        }
        if let idxCanBeRemoved = idxToRemove {
            Database.AllRequests.remove(at: idxCanBeRemoved)
            Database.RespondedToRequests.append(request)
        }
    }
    
    static func resolveRequest(request:HelpPost) {
        var idxToRemove:Int?
        for (i, theRequest) in Database.PendingRequests.enumerated() {
            if (theRequest.titleString == request.titleString) {
                idxToRemove = i
                break
            }
        }
        if let idxCanBeRemoved = idxToRemove {
            Database.PendingRequests.remove(at: idxCanBeRemoved)
        }
    }
    
    static func removeInterestPoint(point: InterestPoint) {
        var idxToRemove:Int?
        for (i, thePoint) in Database.InterestPoints.enumerated() {
            if (thePoint.titleString == point.titleString) {
                idxToRemove = i
                break
            }
        }
        if let idxCanBeRemoved = idxToRemove {
            Database.InterestPoints.remove(at: idxCanBeRemoved)
        }
    }
}
