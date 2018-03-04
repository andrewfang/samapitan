//
//  OnboadingDoneViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/25/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class OnboardingDoneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction private func done() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(true, forKey: "onboarded")
    }

}
