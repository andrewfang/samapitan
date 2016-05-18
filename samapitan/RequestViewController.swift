//
//  RequestViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/12/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum RequestType {
        case MyPending
        case RespondedTo
        case Other
    }
    
    var helpPost:HelpPost!
    var type:RequestType = RequestType.MyPending
    var chatMessage:[Database.ChatMessage]!
    private var keyboardVisible = false
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var textLayoutGuide: NSLayoutConstraint!
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var wantToHelpView: UIView!
    @IBOutlet weak var wantToHelpButton: UIButton!
    
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
    }

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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        switch (type) {
        case RequestType.MyPending:
            fallthrough
        case RequestType.RespondedTo:
            setupChat()
        case RequestType.Other:
            setupJoinView()
        }
    }
    
    private func setupChat() {
        self.wantToHelpView.hidden = true
        self.textInputView.hidden = false
    }
    
    private func setupJoinView() {
        self.textInputView.hidden = true
        self.wantToHelpView.hidden = false
        self.wantToHelpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.wantToHelpButton.layer.cornerRadius = 5.0
        self.wantToHelpButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        self.wantToHelpButton.backgroundColor = UIColor.appBlue()
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
