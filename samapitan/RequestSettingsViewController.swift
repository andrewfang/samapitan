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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section < headerSections.count - 1) {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
            
            let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
            label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
            label.text = self.headerSections[section]
            view.addSubview(label)
            view.backgroundColor = UIColor.appBackgroundColor()
            
            return view
        } else {
            return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == Sections.Urgency.rawValue {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
            
            let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
            label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
            label.text = "Choosing urgent will alert nearby volunteers"
            view.addSubview(label)
            return view
        } else {
            return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == Sections.Desc.rawValue {
            return 100
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (post.type == HelpPost.RequestType.MyPending) {
            return headerSections.count
        } else {
            return headerSections.count - 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == Sections.People.rawValue) {
            return post.membersHelpingOut.count
        } else if (section == Sections.Buttons.rawValue) {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case Sections.Title.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
            cell.textLabel?.text = post.titleString
            return cell
        case Sections.Desc.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "longTextCell", for: indexPath)
            if let cell = cell as? LongTextTableViewCell {
                cell.longLabel.text = post.descriptionString
            }
            return cell
        case Sections.Urgency.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath)
            if let cell = cell as? SelectionSwitchTableViewCell {
                cell.urgencySwitch.selectedSegmentIndex = post.urgency.rawValue
                switch (post.urgency) {
                case .NotUrgent:
                    cell.urgencySwitch.tintColor = UIColor.appBlue()
                case .Urgent:
                    cell.urgencySwitch.tintColor = UIColor.appRed()
                }
                if (post.type == .MyPending) {
                    cell.urgencySwitch.isUserInteractionEnabled = true
                    cell.urgencySwitch.addTarget(self, action: #selector(switchTapped(_:)), for: .valueChanged)
                } else {
                    cell.urgencySwitch.isUserInteractionEnabled = false
                }
            }
            return cell
        case Sections.People.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "peopleHelpingCell", for: indexPath)
            if let cell = cell as? PeopleHelpingTableViewCell {
                cell.profileNameLabel.text = post.membersHelpingOut[indexPath.item].name
                DispatchQueue.main.async {
                    if let url = URL(string: self.post.membersHelpingOut[indexPath.item].imageURL) {
                        if let data = try? Data(contentsOf: url) {
                            OperationQueue.main.addOperation({
                                cell.profileImageView.image = UIImage(data: data)
                            })
                        }
                    }
                }
            }
            
            return cell
        case Sections.Buttons.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
            cell.backgroundColor = UIColor.appBackgroundColor()
            if let cell = cell as? ButtonTableViewCell {
                
                cell.actionButton.setTitleColor(UIColor.white, for: .normal)
                cell.actionButton.layer.cornerRadius = 5.0
                cell.actionButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)

                switch (indexPath.item) {
                case 0:
                    cell.actionButton.setTitle("Cancel Request", for: .normal)
                    cell.actionButton.backgroundColor = UIColor.black
                case 1:
                    cell.actionButton.setTitle("Resolve Request", for: .normal)
                    cell.actionButton.backgroundColor = UIColor.appBlue()
                default:
                    break
                }
            }
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        }
    }
    
    
    @objc func switchTapped(_ control:UISegmentedControl) {
        if (control.selectedSegmentIndex == 0) {
            control.tintColor = UIColor.appBlue()
        } else if (control.selectedSegmentIndex == 1) {
            control.tintColor = UIColor.appRed()
        }
    }
    
    @IBAction private func resolveRequest() {
        Database.resolveRequest(request: self.post)
        self.navigationController?.popToRootViewController(animated: true)
    }
    

}
