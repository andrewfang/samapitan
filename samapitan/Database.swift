//
//  Database.swift
//  samapitan
//
//  Created by Andrew Fang on 5/16/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit
import MapKit

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
    
    static let PeoplePinsToLoad = [
        PeoplePost(coord: CLLocationCoordinate2D(latitude: 37.34, longitude: -122.03),
            name: "Akhila",
            group: "Lifeguard Hellas",
            imageURL:"https://scontent-lax3-1.xx.fbcdn.net/v/t1.0-9/12494723_10154002590118162_47203190040579392_n.jpg?oh=ca23ad457f9f0d16e46e4ae1a5e778e6&oe=57A343AA",
            bio: "I am CPR certified."),
        PeoplePost(coord: CLLocationCoordinate2D(latitude: 37.33, longitude: -122.04),
            name: "Amber",
            group: "Woman's Shelter",
            imageURL:"https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/13131628_459973477526874_6316925508205068443_o.jpg",
            bio: "Stanford Student")
    ]
    
    static var AllRequests = [
        HelpPost(coord: CLLocationCoordinate2D(latitude: 37.33, longitude: -122.06),
            title: "Burrito needed",
            description: "We need help? He seems to need help urgently.",
            urgency: HelpPost.Urgency.Later,
            membersHelpingOut: [Database.PeoplePinsToLoad[1]])
    ]
    
    static var PendingRequests:[HelpPost] = [
        HelpPost(coord: CLLocationCoordinate2D(latitude: 37.32, longitude: -122.04),
            title: "Translator Needed - Farsi",
            description: "We need help communicating with a refugee. He seems to need help urgently.",
            urgency: HelpPost.Urgency.Immediately,
            membersHelpingOut: [Database.PeoplePinsToLoad[0]])
    ]
    
    static var RespondedToRequests:[HelpPost] = [
        
    ]
    
    static var Chats:[String:[ChatMessage]] = [
        "Translator Needed - Farsi": [ChatMessage(textBody: "We need help communicating with a refugee. He seems to need help urgently", owner: .Me, ownerName: ""),
                                    ChatMessage(textBody: "Timon joined the chat", owner: .Joined, ownerName: ""),
                                      ChatMessage(textBody: "I'm on my way", owner: .NotMe, ownerName: "Timon")],
        "Burrito needed": [ChatMessage(textBody: "We need help communicating with a refugee. He seems to need help urgently", owner: .Me, ownerName: ""),
            ChatMessage(textBody: "Timon joined the chat", owner: .Joined, ownerName: ""),
            ChatMessage(textBody: "I'm on my way", owner: .NotMe, ownerName: "Timon")]
    ]
}