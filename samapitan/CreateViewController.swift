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
        
        let createRequest: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "createRequestBoard")
        let createInterest: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "createInterestBoard")
        
        pages.append(createRequest)
        pages.append(createInterest)
        setViewControllers([createRequest], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    @IBAction private func cancel() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func done() {
        if let requestVC = self.viewControllers![0] as? CreateRequestViewController {
            if requestVC.done() {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        } else if let interestVC = self.viewControllers![0] as? CreateInterestViewController {
            if interestVC.done() {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.title = pageViewController.viewControllers![0].title
    }
    

}
