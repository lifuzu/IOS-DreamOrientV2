//
//  HomeViewController.swift
//  DreamOrient
//
//  Created by Richard Lee on 8/4/14.
//  Copyright (c) 2014 Weimed LLC (weimed.com). All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPageViewControllerDataSource {

    // Properties
    var pageViewController: UIPageViewController!
    var pageTitles: [String] = []
    var pageImages: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the data model
        pageTitles = ["Over 200 Tips and Tricks", "Discover Hidden Features", "Bookmark Favorite Tip", "Free Regular Update"]
        pageImages = ["page1.png", "page2.png", "page3.png", "page4.png"]

        // Create page view controller
        self.pageViewController = self.storyboard.instantiateViewControllerWithIdentifier("PageViewController") as UIPageViewController
        self.pageViewController.dataSource = self;

        var startingViewController = self.viewControllerAtIndex(0) as PageContentViewController
        var viewControllers = [startingViewController]
        self.pageViewController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)

        // Change the size of page view controller
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);

        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func viewWillAppear(animated: Bool) {
        // Display toolbar
        self.navigationController.setToolbarHidden(false, animated: true)
    }

    override func viewWillDisappear(animated: Bool) {
        // Hide toolbar
        self.navigationController.setToolbarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func viewControllerAtIndex(index: Int) -> UIViewController! {
        if (self.pageTitles.count == 0 || index >= self.pageTitles.count) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        var pageContentViewController = self.storyboard.instantiateViewControllerWithIdentifier("PageContentViewController") as PageContentViewController
        pageContentViewController.imageFile = self.pageImages[index];
        pageContentViewController.titleText = self.pageTitles[index];
        pageContentViewController.pageIndex = index;

        return pageContentViewController;
    }

    // #pragma mark - Page View Controller Data Source
    func pageViewController(pageViewController: UIPageViewController!, viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController! {
        var index = (viewController as PageContentViewController).pageIndex as Int!

        if (index == 0) {
            return nil
        }

        index!--
        return self.viewControllerAtIndex(index)
    }

    func pageViewController(pageViewController: UIPageViewController!, viewControllerAfterViewController viewController: UIViewController!) -> UIViewController! {
        var index = (viewController as PageContentViewController).pageIndex as Int!

        index!++
        if (index == self.pageTitles.count) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return self.pageTitles.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
