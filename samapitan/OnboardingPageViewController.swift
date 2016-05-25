//
//  OnboardingPageViewController.swift
//  samapitan
//
//  Created by Andrew Fang on 5/24/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    var pagesVisited = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let interestCard: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("interestCard")
        let requestCard: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("requestCard")
        let peopleCard: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("peopleCard")
        let doneCard: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("doneCard")
        
        pages.append(interestCard)
        pages.append(requestCard)
        pages.append(peopleCard)
        pages.append(doneCard)
        
        setViewControllers([interestCard], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        if currentIndex == pages.count - 1 {
            return nil
        } else {
            return pages[currentIndex + 1]
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.pagesVisited += 1
    }
    
}
