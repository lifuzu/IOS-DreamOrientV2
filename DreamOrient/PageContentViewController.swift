//
//  PageContentViewController.swift
//  DreamOrient
//
//  Created by Richard Lee on 8/4/14.
//  Copyright (c) 2014 Weimed LLC (weimed.com). All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    // Properties
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    var pageIndex: Int?
    var titleText: String?
    var imageFile: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.backgroundImageView.image = UIImage(named: imageFile)
        self.titleLabel.text = titleText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
