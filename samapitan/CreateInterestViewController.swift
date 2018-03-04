//
//  CreateInterestViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/20/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit
import MapKit

class CreateInterestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.appTabBarColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.appBackgroundColor()
        
        self.title = "Create Point of Interest"
    }
    
    func done() -> Bool {
        
        guard let titleCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: Sections.Title.rawValue) as IndexPath) as? TextFieldTableViewCell,
            let descCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: Sections.Desc.rawValue) as IndexPath) as? TextViewTableViewCell
            else {
                return false
        }
        
        if let textCount = titleCell.textField.text?.count, textCount < 1 {
            titleCell.textField.placeholder = "The point of interest must have a title"
            return false
        }
        
        let title = titleCell.textField.text!
        let desc = descCell.textView.text
        
        var location = CLLocationCoordinate2D(latitude: 37.32, longitude: -122.04)
        let lat = UserDefaults.standard.double(forKey: "lat") + 0.00002
        let long = UserDefaults.standard.double(forKey: "long")
        if lat != long {
            location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        Database.InterestPoints.append(InterestPoint(coord: location, title: title, description: desc ?? "", photo: selectedImage ?? UIImage(named: "placeholder")!))
        return true
    }
    
    @IBOutlet weak var tableView:UITableView!
    
    enum Sections:Int {
        case Title = 0
        case Desc = 1
        case Photo = 2
    }
    
    let headerSections = ["TITLE", "DESCRIPTION", "PHOTO"]
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        label.text = self.headerSections[section]
        view.addSubview(label)
        view.backgroundColor = UIColor.appBackgroundColor()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        case Sections.Photo.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
            if let cell = cell as? ButtonTableViewCell {
                self.imageButton = cell.actionButton
                cell.actionButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
            }
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        }
    }
    
    private var imageButton: UIButton!
    private var imagePicker:UIImagePickerController!
    private var selectedImage: UIImage?
    
    
    @IBAction func takePhoto(sender: UIButton) {
        let optionPicker = UIAlertController(title: "Snap a photo", message: "", preferredStyle: .actionSheet)
        
        // Allow user to take a photo
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            optionPicker.addAction(alertActionWithPickerType(pickerType: .camera, title: "Camera"))
        }
        
        // Allow user to choose from saved photos
        if (UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)) {
            optionPicker.addAction(alertActionWithPickerType(pickerType: .savedPhotosAlbum, title: "Album"))
        }
        
        optionPicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(optionPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss(animated: true, completion: nil)
        self.selectedImage = image
        self.imageButton.setImage(image, for: .normal)
        
    }
    
    // Add in a alert action option that triggers a UIImagePickerController
    private func alertActionWithPickerType(pickerType:UIImagePickerControllerSourceType, title:String) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default, handler: { action in
            let imgPicker = UIImagePickerController()
            imgPicker.allowsEditing = true
            imgPicker.delegate = self
            imgPicker.sourceType = pickerType
            imgPicker.navigationBar.isTranslucent = true
            imgPicker.navigationBar.tintColor = UIColor.white
            imgPicker.navigationBar.barTintColor = UIColor.appTabBarColor()
            imgPicker.navigationBar.titleTextAttributes = [
                NSAttributedStringKey.foregroundColor : UIColor.white
            ]
            self.present(imgPicker, animated: true, completion: nil)
        })
    }

    // Called on cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITextView Delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}
