
//
//  SettingsViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/10/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    @IBAction private func done() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private enum Sections:Int {
        case About = 0
        case Group = 1
        case Connected = 2
        case Settings = 3
    }
    
    var requests:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.appBackgroundColor()
        self.requests = []
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    let headerSections = ["ABOUT ME", "GROUP", "CONNECTED SERVICES", "SETTINGS"]
    
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
            let cell = tableView.dequeueReusableCellWithIdentifier("EditTextCell", forIndexPath: indexPath)
            return cell
        case Sections.Group.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Disaster Tech Lab"
            return cell
        case Sections.Connected.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath)
            if (indexPath.item == 0) {
                cell.textLabel?.text = "WhatsApp"
            } else if (indexPath.item == 1) {
                cell.textLabel?.text = "Connect to Facebook"
            }
            return cell
        case Sections.Settings.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath)
            if let cell = cell as? SwitchTableViewCell {
                cell.titleLabel.text = "Available to help"
                cell.settingsSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey("available")
                cell.settingsSwitch.addTarget(self, action: #selector(SettingsViewController.toggleSwitch(_:)), forControlEvents: .AllTouchEvents)
            }
            
            cell.setNeedsLayout()
            return cell
        default:
            return tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath)
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
        case Sections.Connected.rawValue:
            return 2
        case Sections.Settings.rawValue:
            return 1
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
