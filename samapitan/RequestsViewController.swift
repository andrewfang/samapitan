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
    
    var headerSections = ["MY PENDING REQUESTS", "REQUESTS I'VE RESPONDED TO", "OTHER REQUESTS AROUND ME"]
    
    @IBOutlet weak var tableView:UITableView!
    
    enum RequestSections:Int {
        case Pending = 0
        case RespondedTo = 1
        case AroundMe = 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "View Requests"
        
        self.navigationController?.navigationBar.barTintColor = UIColor.appTabBarColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        self.pendingRequests = Database.PendingRequests
        self.respondedToRequests = Database.RespondedToRequests
        self.otherRequests = Database.AllRequests
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.appBackgroundColor()
    }
    
    // MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("request cell", forIndexPath: indexPath) as? BorderedTableViewCell else {
            return tableView.dequeueReusableCellWithIdentifier("request cell", forIndexPath: indexPath)
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
        
        let label = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width, 18))
        label.font = UIFont.systemFontOfSize(12, weight: UIFontWeightThin)
        label.text = self.headerSections[section]
        view.addSubview(label)
        view.backgroundColor = UIColor.appBackgroundColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("REQUEST_SEGUE", sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexPath = sender as? NSIndexPath else {
            return
        }
        
        if segue.identifier == "REQUEST_SEGUE" {
            if let requestvc = segue.destinationViewController as? RequestViewController {
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
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
