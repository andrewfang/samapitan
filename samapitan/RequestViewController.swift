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
        
        UIView.animate(withDuration: 0.4, animations: {
            self.textInputView.alpha = 1
            self.wantToHelpView.alpha = 0
            }, completion: { done in
                self.textInputView.isHidden = false
                self.textInputView.alpha = 1
                self.wantToHelpView.isHidden = true
                self.wantToHelpView.alpha = 1
        })
        
        self.helpPost.type = HelpPost.RequestType.MyResponded
        let message = Database.ChatMessage(textBody: "You joined the chat", owner: .Joined, ownerName: "")
        Database.Chats[self.helpPost.titleString]?.append(message)
        self.chatMessage.append(message)
        self.tableView.insertRows(at: [IndexPath(row: self.chatMessage.count - 1, section: 0)], with: .top)
        Database.respondToRequest(request: self.helpPost)
//        if let requestsVc = self.navigationController?.viewControllers.first as? RequestsViewController {
//            requestsVc
//        }
    }
    
    @IBAction func sendMessage() {
        if let textCount = self.textView.text?.count, textCount > 0 {
            let message = Database.ChatMessage(textBody: self.textView.text!, owner: .Me, ownerName: "")
            self.chatMessage.append(message)
            Database.Chats[self.helpPost.titleString]?.append(message)
            self.textView.text = nil
            self.tableView.insertRows(at: [IndexPath.init(row: self.chatMessage.count - 1, section: 0)], with: .top)
            let indexPath = IndexPath(row: self.chatMessage.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
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
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "settings"), style: .done, target: self, action: #selector(showSettings))]
        
        NotificationCenter.default.addObserver(self, selector: #selector(RequestViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RequestViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RequestViewController.keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RequestViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
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
        self.wantToHelpView.isHidden = true
        self.textInputView.isHidden = false
        
    }
    
    private func setupJoinView() {
        self.textInputView.isHidden = true
        self.wantToHelpView.isHidden = false
        self.wantToHelpButton.setTitleColor(UIColor.white, for: .normal)
        self.wantToHelpButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        
        switch (self.helpPost.urgency) {
        case .Urgent:
            self.wantToHelpButton.backgroundColor = UIColor.appRed()
        case .NotUrgent:
            self.wantToHelpButton.backgroundColor = UIColor.appBlue() 
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToDeque = ""
        if chatMessage[indexPath.item].owner == Database.ChatOwner.Me {
            cellToDeque = "meCell"
        } else if chatMessage[indexPath.item].owner == Database.ChatOwner.Joined {
            cellToDeque = "joinedCell"
        } else {
            cellToDeque = "notMeCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellToDeque, for: indexPath)
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
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        self.keyboardVisible = true
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            UIView.animate(withDuration: 0.3, animations: {
                self.textLayoutGuide.constant = keyboardSize.height
            })
        }
    }
    
    @objc func keyboardWillChange(_ notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
            UIView.animate(withDuration: 0.3, animations: {
                if (self.keyboardVisible) {
                    self.textLayoutGuide.constant = keyboardSize.height
                } else {
                    self.textLayoutGuide.constant = 0
                }
            })
        }
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification) {
        let indexPath = IndexPath(row: self.chatMessage.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.keyboardVisible = false
        UIView.animate(withDuration: 0.3, animations: {
                self.textLayoutGuide.constant = 0
        })
    }
    
    @objc func showSettings() {
        self.performSegue(withIdentifier: "showSettingsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettingsSegue" {
            if let settingsvc = segue.destination as? RequestSettingsViewController {
                settingsvc.post = helpPost
            }
        }
    }
}
