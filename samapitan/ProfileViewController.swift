//
//  ProfileViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/12/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var personImageView:UIImageView!
    @IBOutlet weak var personNameLabel:UILabel!
    @IBOutlet weak var tableView:UITableView!

    var person:PeoplePost!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.personNameLabel.text = self.person.name
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.appBackgroundColor()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        if let url = NSURL(string: self.person.imageURL) {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
                if let data = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue()){
                        if let image = UIImage(data: data) {
                            self.personImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }
    
    // MARK: - TableView
    private enum Sections:Int {
        case About = 0
        case Group = 1
        case Contact = 2
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    let headerSections = ["ABOUT ME", "GROUP", "CONTACT"]
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
        
        let label = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width, 18))
        label.font = UIFont.systemFontOfSize(12, weight: UIFontWeightThin)
        label.text = self.headerSections[section]
        view.addSubview(label)
        view.backgroundColor = UIColor.appBackgroundColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
        case Sections.About.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
            cell.textLabel?.text = self.person.bio
            return cell
        case Sections.Group.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
            cell.textLabel?.text = self.person.group
            return cell
        case Sections.Contact.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath)
            if let cell = cell as? ContactTableViewCell {
                if (indexPath.item == 0) {
                    cell.titleLabel.text = "WhatsApp Message"
                    cell.contactButton.setImage(UIImage(named: "whatsapp"), forState: .Normal)
                } else if (indexPath.item == 1) {
                    cell.titleLabel.text = "Facebook Message"
                    cell.contactButton.setImage(UIImage(named: "facebook"), forState: .Normal)
                }
                
            }
            
            return cell
        default:
            return tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
        }
    }
    
    func toggleSwitch(switchBtn:UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(switchBtn.on, forKey: "available")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case Sections.About.rawValue:
            return 1
        case Sections.Group.rawValue:
            return 1
        case Sections.Contact.rawValue:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
}
