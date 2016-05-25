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
    private var keyboardVisible = false
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var textLayoutGuide: NSLayoutConstraint!
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var wantToHelpView: UIView!
    @IBOutlet weak var wantToHelpButton: UIButton!
    @IBOutlet weak var textView: UITextField!
    
    @IBAction func joinChat() {
        
        UIView.animateWithDuration(0.4, animations: {
            self.textInputView.alpha = 1
            self.wantToHelpView.alpha = 0
            }, completion: { done in
                self.textInputView.hidden = false
                self.textInputView.alpha = 1
                self.wantToHelpView.hidden = true
                self.wantToHelpView.alpha = 1
        })
        
        self.helpPost.type = HelpPost.RequestType.MyResponded
        let message = Database.ChatMessage(textBody: "You joined the chat", owner: .Joined, ownerName: "")
        Database.Chats[self.helpPost.titleString]?.append(message)
        self.chatMessage.append(message)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chatMessage.count - 1, inSection: 0)], withRowAnimation: .Top)
        Database.respondToRequest(self.helpPost)
//        if let requestsVc = self.navigationController?.viewControllers.first as? RequestsViewController {
//            requestsVc
//        }
    }
    
    @IBAction func sendMessage() {
        if (self.textView.text?.characters.count > 0) {
            
            let message = Database.ChatMessage(textBody: self.textView.text!, owner: .Me, ownerName: "")
            self.chatMessage.append(message)
            Database.Chats[self.helpPost.titleString]?.append(message)
            self.textView.text = nil
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chatMessage.count - 1, inSection: 0)], withRowAnimation: .Top)
            let indexPath = NSIndexPath(forRow: self.chatMessage.count - 1, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = helpPost.titleString
        self.chatMessage = Database.Chats[self.helpPost.titleString]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "settings"), style: .Done, target: self, action: #selector(showSettings))]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RequestViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RequestViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RequestViewController.keyboardWillChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RequestViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
        switch (helpPost.type) {
        case HelpPost.RequestType.MyPending:
            fallthrough
        case HelpPost.RequestType.MyResponded:
            setupChat()
        case HelpPost.RequestType.Other:
            setupJoinView()
        }
        
        self.textInputView.backgroundColor = UIColor.appTabBarColor()
        self.wantToHelpView.backgroundColor = UIColor.appTabBarColor()
    }
    
    private func setupChat() {
        self.wantToHelpView.hidden = true
        self.textInputView.hidden = false
        
    }
    
    private func setupJoinView() {
        self.textInputView.hidden = true
        self.wantToHelpView.hidden = false
        self.wantToHelpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.wantToHelpButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        
        switch (self.helpPost.urgency) {
        case .Urgent:
            self.wantToHelpButton.backgroundColor = UIColor.appRed()
        case .NotUrgent:
            self.wantToHelpButton.backgroundColor = UIColor.appBlue() 
        }
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
            } else if chatMessage[indexPath.item].owner == Database.ChatOwner.Me {
                cell.content.backgroundColor = UIColor.appBlue()
            }
        }
        
        return cell
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.keyboardVisible = true
        
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
            UIView.animateWithDuration(0.3, animations: {
                self.textLayoutGuide.constant = keyboardSize.height
            })
        }
    }
    
    func keyboardWillChange(notification:NSNotification) {
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
            UIView.animateWithDuration(0.3, animations: {
                if (self.keyboardVisible) {
                    self.textLayoutGuide.constant = keyboardSize.height
                } else {
                    self.textLayoutGuide.constant = 0
                }
            })
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let indexPath = NSIndexPath(forRow: self.chatMessage.count - 1, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.keyboardVisible = false
        UIView.animateWithDuration(0.3, animations: {
                self.textLayoutGuide.constant = 0
        })
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
