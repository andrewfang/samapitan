//
//  RequestViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/12/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var helpPost:HelpPost!
    var chatMessage:[Database.ChatMessage]!
    
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = helpPost.titleString
        self.chatMessage = Database.Chats[self.helpPost.titleString]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "settings"), style: .Done, target: self, action: #selector(showSettings))]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessage.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellToDeque = ""
        if chatMessage[indexPath.item].owner == Database.ChatOwner.Me {
            cellToDeque = "meCell"
        } else if chatMessage[indexPath.item].owner == Database.ChatOwner.Joined {
            cellToDeque = "joinedCell"
        } else {
            cellToDeque = "notMeCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellToDeque, forIndexPath: indexPath)
        if let cell = cell as? ChatTableViewCell {
            cell.content.text = chatMessage[indexPath.item].textBody
            if chatMessage[indexPath.item].owner == Database.ChatOwner.NotMe {
                cell.nameLabel.text = chatMessage[indexPath.item].ownerName
            }
        }
        
        return cell
    }
    
    func showSettings() {
        self.performSegueWithIdentifier("showSettingsSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSettingsSegue" {
            if let settingsvc = segue.destinationViewController as? RequestSettingsViewController {
                settingsvc.post = helpPost
            }
        }
    }
}
