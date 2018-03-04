
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
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    let headerSections = ["ABOUT ME", "GROUP", "CONNECTED SERVICES", "SETTINGS"]
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        label.text = self.headerSections[section]
        view.addSubview(label)
        view.backgroundColor = UIColor.appBackgroundColor()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case Sections.About.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTextCell", for: indexPath)
            return cell
        case Sections.Group.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            cell.textLabel?.text = "Disaster Tech Lab"
            return cell
        case Sections.Connected.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            if (indexPath.item == 0) {
                cell.textLabel?.text = "WhatsApp"
            } else if (indexPath.item == 1) {
                cell.textLabel?.text = "Connect to Facebook"
            }
            return cell
        case Sections.Settings.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
            if let cell = cell as? SwitchTableViewCell {
                cell.titleLabel.text = "Available to help"
                cell.settingsSwitch.isOn = UserDefaults.standard.bool(forKey: "available")
                cell.settingsSwitch.addTarget(self, action: #selector(toggleSwitch(_:)), for: .allTouchEvents)
            }
            
            cell.setNeedsLayout()
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        }
    }
    
    @objc func toggleSwitch(_ switchBtn:UISwitch) {
        UserDefaults.standard.set(switchBtn.isOn, forKey: "available")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
