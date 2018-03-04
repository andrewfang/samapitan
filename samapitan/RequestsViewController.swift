//
//  RequestsViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/11/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var pendingRequests:[HelpPost]!
    var respondedToRequests:[HelpPost]!
    var otherRequests:[HelpPost]!
    
    var headerSections = ["MY HELP REQUESTS", "HELP REQUESTS RESPONDED TO", "OTHER HELP REQUESTS AROUND ME"]
    
    @IBOutlet weak var tableView:UITableView!
    
    enum RequestSections:Int {
        case Pending = 0
        case RespondedTo = 1
        case AroundMe = 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "View Help Requests"
        
        self.navigationController?.navigationBar.barTintColor = UIColor.appTabBarColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white

        self.pendingRequests = Database.PendingRequests
        self.respondedToRequests = Database.RespondedToRequests
        self.otherRequests = Database.AllRequests
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.appBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pendingRequests = Database.PendingRequests
        self.respondedToRequests = Database.RespondedToRequests
        self.otherRequests = Database.AllRequests
        self.tableView.reloadData()
    }
    
    // MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case RequestSections.Pending.rawValue:
            return self.pendingRequests.count
        case RequestSections.RespondedTo.rawValue:
            return self.respondedToRequests.count
        case RequestSections.AroundMe.rawValue:
            return otherRequests.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "request cell", for: indexPath) as? BorderedTableViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: "request cell", for: indexPath)
        }
        
        switch (indexPath.section) {
        case RequestSections.Pending.rawValue:
            cell.contentLabel.text = self.pendingRequests[indexPath.item].titleString
            cell.colorView.backgroundColor = self.pendingRequests[indexPath.item].color
            cell.timeLabel.text = self.pendingRequests[indexPath.item].timePosted
        case RequestSections.RespondedTo.rawValue:
            cell.contentLabel.text = self.respondedToRequests[indexPath.item].titleString
            cell.colorView.backgroundColor = self.respondedToRequests[indexPath.item].color
            cell.timeLabel.text = self.respondedToRequests[indexPath.item].timePosted
        case RequestSections.AroundMe.rawValue:
            cell.contentLabel.text = self.otherRequests[indexPath.item].titleString
            cell.colorView.backgroundColor = self.otherRequests[indexPath.item].color
            cell.timeLabel.text = self.otherRequests[indexPath.item].timePosted
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        label.text = self.headerSections[section]
        view.addSubview(label)
        view.backgroundColor = UIColor.appBackgroundColor()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "REQUEST_SEGUE", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? NSIndexPath else {
            return
        }
        
        if segue.identifier == "REQUEST_SEGUE" {
            if let requestvc = segue.destination as? RequestViewController {
                switch (indexPath.section) {
                case RequestSections.Pending.rawValue:
                    requestvc.helpPost = self.pendingRequests[indexPath.item]
                case RequestSections.RespondedTo.rawValue:
                    requestvc.helpPost = self.respondedToRequests[indexPath.item]
                case RequestSections.AroundMe.rawValue:
                    requestvc.helpPost = self.otherRequests[indexPath.item]
                default:
                    break
                }
            }
        }
    }
    
    @IBAction private func done() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
