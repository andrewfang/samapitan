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
        
        if let url = NSURL(string: self.person.imageURL) {
            DispatchQueue.main.async {
                if let data = try? Data(contentsOf: url as URL) {
                    if let image = UIImage(data: data) {
                        self.personImageView.image = image
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
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
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        label.text = self.headerSections[section]
        view.addSubview(label)
        view.backgroundColor = UIColor.appBackgroundColor()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case Sections.About.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LongTextCell", for: indexPath)
            if let cell = cell as? LongTextTableViewCell {
                cell.longLabel.text = self.person.bio
            }
            return cell
        case Sections.Group.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            cell.textLabel?.text = self.person.group
            return cell
        case Sections.Contact.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
            if let cell = cell as? ContactTableViewCell {
                if (indexPath.item == 0) {
                    cell.titleLabel.text = "WhatsApp Message"
                    cell.contactButton.setImage(UIImage(named: "whatsapp"), for: .normal)
                } else if (indexPath.item == 1) {
                    cell.titleLabel.text = "Facebook Message"
                    cell.contactButton.setImage(UIImage(named: "facebook"), for: .normal)
                }
            }
            
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
        }
    }
    
    func toggleSwitch(switchBtn:UISwitch) {
        UserDefaults.standard.set(switchBtn.isOn, forKey: "available")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
}
