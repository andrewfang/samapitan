//
//  CreateViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/19/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class CreateViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        self.title = "Create Help Request"
        
        let createRequest: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("createRequestBoard")
        let createInterest: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("createInterestBoard")
        
        pages.append(createRequest)
        pages.append(createInterest)
        setViewControllers([createRequest], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    @IBAction private func cancel() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func done() {
        if let requestVC = self.viewControllers![0] as? CreateRequestViewController {
            if requestVC.done() {
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        } else if let interestVC = self.viewControllers![0] as? CreateInterestViewController {
            if interestVC.done() {
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.title = pageViewController.viewControllers![0].title
    }
    

}
