//
//  InterestViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/18/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class InterestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var interestPoint: InterestPoint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    enum Sections:Int {
        case Title = 0
        case Desc = 1
        case Buttons = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = interestPoint.titleString
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.appBackgroundColor()
        
        self.imageView.image = self.interestPoint.photo
    }
    
    let headerSections = ["TITLE", "DESCRIPTION", "Buttons"]
    
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == Sections.Desc.rawValue {
            return 200
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
            let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
            cell.textLabel?.text = interestPoint.titleString
            return cell
        case Sections.Desc.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("longTextCell", forIndexPath: indexPath)
            if let cell = cell as? LongTextTableViewCell {
                cell.longLabel.text = interestPoint.descriptionString
            }
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
                    cell.actionButton.setTitle("Remove Interest Point", forState: .Normal)
                    cell.actionButton.backgroundColor = UIColor.appRed()
                default:
                    break
                }
            }
            return cell
        default:
            return tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
        }
    }
    
    @IBAction func removeInterestPoint() {
        Database.removeInterestPoint(self.interestPoint)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
