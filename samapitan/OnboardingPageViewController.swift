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
        
        let interestCard: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "interestCard")
        let requestCard: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "requestCard")
        let peopleCard: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "peopleCard")
        let doneCard: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "doneCard")
        
        pages.append(interestCard)
        pages.append(requestCard)
        pages.append(peopleCard)
        pages.append(doneCard)
        
        setViewControllers([interestCard], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        if currentIndex == pages.count - 1 {
            return nil
        } else {
            return pages[currentIndex + 1]
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.pagesVisited += 1
    }
    
}
