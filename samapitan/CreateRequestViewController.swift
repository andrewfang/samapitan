//
//  CreateRequestViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/11/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class CreateRequestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction private func done() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func cancel() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
