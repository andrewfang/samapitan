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
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.appBackgroundColor()

        self.title = "Create New Request"
    }

    func done() -> Bool {
        guard let titleCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: Sections.Title.rawValue)) as? TextFieldTableViewCell,
            let descCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: Sections.Desc.rawValue)) as? TextViewTableViewCell,
            let switchCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: Sections.Urgency.rawValue)) as? SelectionSwitchTableViewCell
        else {
            return false
        }
        
        if let charCount = titleCell.textField.text?.count, charCount < 1 {
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
        let lat = UserDefaults.standard.double(forKey: "lat") + 0.00002
        let long = UserDefaults.standard.double(forKey: "long")
        if lat != long {
            location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        let date = Date()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.hour,.minute], from: date)
        let hour = components.hour
        let minutes = components.minute
        
        Database.PendingRequests.append(HelpPost(coord: location,
            title: title,
            description: desc ?? "",
            urgency: urgency,
            type: HelpPost.RequestType.MyPending,
            timePosted: "\(hour ?? 0):\(minutes ?? 0)",
            membersHelpingOut: []))
        
        Database.Chats[title] = [Database.ChatMessage(textBody: desc ?? "", owner: .Me, ownerName: "")]
        return true
    }
    
    @IBAction private func cancel() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView:UITableView!
    
    var post:HelpPost!
    
    enum Sections:Int {
        case Title = 0
        case Desc = 1
        case Urgency = 2
    }
    
    let headerSections = ["TITLE", "DESCRIPTION", "URGENCY"]
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        label.text = self.headerSections[section]
        view.addSubview(label)
        view.backgroundColor = UIColor.appBackgroundColor()
        
        return view
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
        return headerSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case Sections.Title.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath)
            if let tfCell = cell as? TextFieldTableViewCell {
                tfCell.textField.addTarget(tfCell.textField, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
            }
            return cell
        case Sections.Desc.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textViewCell", for: indexPath)
            if let tvCell = cell as? TextViewTableViewCell {
                tvCell.textView.delegate = self
            }
            return cell
        case Sections.Urgency.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath)
            if let cell = cell as? SelectionSwitchTableViewCell {
                cell.urgencySwitch.selectedSegmentIndex = 0
                cell.urgencySwitch.tintColor = UIColor.appBlue()
                cell.urgencySwitch.addTarget(self, action: #selector(switchTapped(_:)), for: .valueChanged)
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
    
    // MARK: UITextView Delegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }

}
