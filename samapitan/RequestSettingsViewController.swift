//
//  RequestSettingsViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/17/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class RequestSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView:UITableView!
    
    var post:HelpPost!
    
    enum Sections:Int {
        case Title = 0
        case Desc = 1
        case Urgency = 2
        case People = 3
        case Buttons = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.appBackgroundColor()
    }
    
    let headerSections = ["TITLE", "DESCRIPTION", "URGENCY", "PEOPLE HELPING OUT", "Buttons"]
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section < headerSections.count - 1) {
            let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
            
            let label = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width, 18))
            label.font = UIFont.systemFontOfSize(12, weight: UIFontWeightThin)
            label.text = self.headerSections[section]
            view.addSubview(label)
            view.backgroundColor = UIColor.appBackgroundColor()
            
            return view
        } else {
            return UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 0))
        }
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
        if (section == Sections.People.rawValue) {
            return post.membersHelpingOut.count
        } else if (section == Sections.Buttons.rawValue) {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
        case Sections.Title.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
            cell.textLabel?.text = post.titleString
            return cell
        case Sections.Desc.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("longTextCell", forIndexPath: indexPath)
            if let cell = cell as? LongTextTableViewCell {
                cell.longLabel.text = post.descriptionString
            }
            return cell
        case Sections.Urgency.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath)
            if let cell = cell as? SelectionSwitchTableViewCell {
                cell.urgencySwitch.selectedSegmentIndex = post.urgency.rawValue
            }
            return cell
        case Sections.People.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("peopleHelpingCell", forIndexPath: indexPath)
            cell.textLabel?.text = post.membersHelpingOut[indexPath.item].name
            return cell
        case Sections.Buttons.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("buttonCell", forIndexPath: indexPath)
            cell.backgroundColor = UIColor.appBackgroundColor()
            if let cell = cell as? ButtonTableViewCell {
                
                cell.actionButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                cell.actionButton.layer.cornerRadius = 5.0
                cell.actionButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)

                switch (indexPath.item) {
                case 0:
                    cell.actionButton.setTitle("Cancel Request", forState: .Normal)
                    cell.actionButton.backgroundColor = UIColor.blackColor()
                case 1:
                    cell.actionButton.setTitle("Resolve Request", forState: .Normal)
                    cell.actionButton.backgroundColor = UIColor.appBlue()
                default:
                    break
                }
            }
            return cell
        default:
            return tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
        }
    }
    
    

}
