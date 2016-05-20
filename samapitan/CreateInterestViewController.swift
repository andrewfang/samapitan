//
//  CreateInterestViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/20/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit
import MapKit

class CreateInterestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.appTabBarColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.appBackgroundColor()
        
        self.title = "Create Interest Point"
    }
    
    func done() {
        
        guard let titleCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: Sections.Title.rawValue)) as? TextFieldTableViewCell,
            descCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: Sections.Desc.rawValue)) as? TextViewTableViewCell
            else {
                return
        }
        
        if titleCell.textField.text?.characters.count < 1 {
            titleCell.textField.placeholder = "The interest point must have a title"
            return
        }
        
        let title = titleCell.textField.text!
        let desc = descCell.textView.text
        
        var location = CLLocationCoordinate2D(latitude: 37.32, longitude: -122.04)
        let lat = NSUserDefaults.standardUserDefaults().doubleForKey("lat")
        let long = NSUserDefaults.standardUserDefaults().doubleForKey("long")
        if lat != long {
            location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        Database.InterestPoints.append(InterestPoint(coord: location, title: title, description: desc, photo: selectedImage ?? UIImage(named: "placeholder")!))
    }
    
    @IBOutlet weak var tableView:UITableView!
    
    enum Sections:Int {
        case Title = 0
        case Desc = 1
        case Photo = 2
    }
    
    let headerSections = ["TITLE", "DESCRIPTION", "PHOTO"]
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
        
        let label = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width, 18))
        label.font = UIFont.systemFontOfSize(12, weight: UIFontWeightThin)
        label.text = self.headerSections[section]
        view.addSubview(label)
        view.backgroundColor = UIColor.appBackgroundColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == Sections.Desc.rawValue {
            return 100
        } else if indexPath.section == Sections.Photo.rawValue {
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
            return tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath)
        case Sections.Desc.rawValue:
            return tableView.dequeueReusableCellWithIdentifier("textViewCell", forIndexPath: indexPath)
        case Sections.Photo.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("buttonCell", forIndexPath: indexPath)
            if let cell = cell as? ButtonTableViewCell {
                self.imageButton = cell.actionButton
                cell.actionButton.addTarget(self, action: #selector(takePhoto), forControlEvents: .TouchUpInside)
            }
            return cell
        default:
            return tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
        }
    }
    
    private var imageButton: UIButton!
    private var imagePicker:UIImagePickerController!
    private var selectedImage: UIImage?
    
    
    @IBAction func takePhoto(sender: UIButton) {
        let optionPicker = UIAlertController(title: "Snap a photo", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // Allow user to take a photo
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            optionPicker.addAction(alertActionWithPickerType(.Camera, title: "Camera"))
        }
        
        // Allow user to choose from saved photos
        if (UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum)) {
            optionPicker.addAction(alertActionWithPickerType(.SavedPhotosAlbum, title: "Album"))
        }
        
        optionPicker.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(optionPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.selectedImage = image
        self.imageButton.setImage(image, forState: .Normal)
        
    }
    
    // Add in a alert action option that triggers a UIImagePickerController
    private func alertActionWithPickerType(pickerType:UIImagePickerControllerSourceType, title:String) -> UIAlertAction {
        return UIAlertAction(title: title, style: .Default, handler: { action in
            let imgPicker = UIImagePickerController()
            imgPicker.allowsEditing = true
            imgPicker.delegate = self
            imgPicker.sourceType = pickerType
            imgPicker.navigationBar.translucent = true
            imgPicker.navigationBar.tintColor = UIColor.whiteColor()
            imgPicker.navigationBar.barTintColor = UIColor.appTabBarColor()
            imgPicker.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor()
            ]
            self.presentViewController(imgPicker, animated: true, completion: nil)
        })
    }

    // Called on cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
