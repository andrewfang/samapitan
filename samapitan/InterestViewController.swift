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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == Sections.Desc.rawValue {
            return 200
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
            cell.textLabel?.text = interestPoint.titleString
            return cell
        case Sections.Desc.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "longTextCell", for: indexPath)
            if let cell = cell as? LongTextTableViewCell {
                cell.longLabel.text = interestPoint.descriptionString
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
                    cell.actionButton.setTitle("Remove Interest Point", for: .normal)
                    cell.actionButton.backgroundColor = UIColor.appRed()
                default:
                    break
                }
            }
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        }
    }
    
    @IBAction func removeInterestPoint() {
        Database.removeInterestPoint(point: self.interestPoint)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
