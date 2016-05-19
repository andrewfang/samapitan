//
//  CreateRequestViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/11/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit
import MapKit

class CreateRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction private func done() {
        
        
        guard let titleCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: Sections.Title.rawValue)) as? TextFieldTableViewCell,
            descCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: Sections.Desc.rawValue)) as? TextViewTableViewCell,
            switchCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: Sections.Urgency.rawValue)) as? SelectionSwitchTableViewCell
        else {
            return
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
        let lat = NSUserDefaults.standardUserDefaults().doubleForKey("lat")
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
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
            return tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath)
        case Sections.Desc.rawValue:
            return tableView.dequeueReusableCellWithIdentifier("textViewCell", forIndexPath: indexPath)
        case Sections.Urgency.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath)
            if let cell = cell as? SelectionSwitchTableViewCell {
                cell.urgencySwitch.selectedSegmentIndex = 0
                cell.urgencySwitch.tintColor = UIColor.appGreen()
                cell.urgencySwitch.addTarget(self, action: #selector(switchTapped(_:)), forControlEvents: .ValueChanged)
            }
            return cell
        default:
            return tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
        }
    }

    func switchTapped(control:UISegmentedControl) {
        if (control.selectedSegmentIndex == 0) {
            control.tintColor = UIColor.appGreen()
        } else if (control.selectedSegmentIndex == 1) {
            control.tintColor = UIColor.appRed()
        }
    }

}
