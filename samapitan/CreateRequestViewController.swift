//
//  CreateRequestViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/11/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit
import MapKit

class CreateRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.appTabBarColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.appBackgroundColor()

        self.title = "Create New Request"
    }

    func done() -> Bool {
        
        guard let titleCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: Sections.Title.rawValue)) as? TextFieldTableViewCell,
            descCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: Sections.Desc.rawValue)) as? TextViewTableViewCell,
            switchCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: Sections.Urgency.rawValue)) as? SelectionSwitchTableViewCell
        else {
            return false
        }
        
        if titleCell.textField.text?.characters.count < 1 {
            titleCell.textField.placeholder = "Your request must have a title"
            return false
        }
        
        let title = titleCell.textField.text!
        let desc = descCell.textView.text
        var urgency:HelpPost.Urgency
        switch (switchCell.urgencySwitch.selectedSegmentIndex) {
        case 0:
            urgency = HelpPost.Urgency.NotUrgent
        case 1:
            urgency = HelpPost.Urgency.Urgent
        default:
            urgency = HelpPost.Urgency.Urgent
        }
        
        var location = CLLocationCoordinate2D(latitude: 37.32, longitude: -122.04)
        let lat = NSUserDefaults.standardUserDefaults().doubleForKey("lat") + 0.00002
        let long = NSUserDefaults.standardUserDefaults().doubleForKey("long")
        if lat != long {
            location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour,.Minute], fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        
        Database.PendingRequests.append(HelpPost(coord: location,
            title: title,
            description: desc,
            urgency: urgency,
            type: HelpPost.RequestType.MyPending,
            timePosted: "\(hour):\(minutes)",
            membersHelpingOut: []))
        
        Database.Chats[title] = [Database.ChatMessage(textBody: desc, owner: .Me, ownerName: "")]
        return true
    }
    
    @IBAction private func cancel() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var tableView:UITableView!
    
    var post:HelpPost!
    
    enum Sections:Int {
        case Title = 0
        case Desc = 1
        case Urgency = 2
    }
    
    let headerSections = ["TITLE", "DESCRIPTION", "URGENCY"]
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
        
        let label = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width, 18))
        label.font = UIFont.systemFontOfSize(12, weight: UIFontWeightThin)
        label.text = self.headerSections[section]
        view.addSubview(label)
        view.backgroundColor = UIColor.appBackgroundColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == Sections.Urgency.rawValue {
            let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
            
            let label = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width, 18))
            label.font = UIFont.systemFontOfSize(12, weight: UIFontWeightThin)
            label.text = "Choosing immediately will alert nearby volunteers"
            view.addSubview(label)
            return view
        } else {
            return UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 0))
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == Sections.Desc.rawValue {
            return 100
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headerSections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
        case Sections.Title.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath)
            if let tfCell = cell as? TextFieldTableViewCell {
                tfCell.textField.addTarget(tfCell.textField, action: #selector(resignFirstResponder), forControlEvents: .EditingDidEndOnExit)
            }
            return cell
        case Sections.Desc.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("textViewCell", forIndexPath: indexPath)
            if let tvCell = cell as? TextViewTableViewCell {
                tvCell.textView.delegate = self
            }
            return cell
        case Sections.Urgency.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath)
            if let cell = cell as? SelectionSwitchTableViewCell {
                cell.urgencySwitch.selectedSegmentIndex = 0
                cell.urgencySwitch.tintColor = UIColor.appBlue()
                cell.urgencySwitch.addTarget(self, action: #selector(switchTapped(_:)), forControlEvents: .ValueChanged)
            }
            return cell
        default:
            return tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
        }
    }

    func switchTapped(control:UISegmentedControl) {
        if (control.selectedSegmentIndex == 0) {
            control.tintColor = UIColor.appBlue()
        } else if (control.selectedSegmentIndex == 1) {
            control.tintColor = UIColor.appRed()
        }
    }
    
    // MARK: UITextView Delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }

}
