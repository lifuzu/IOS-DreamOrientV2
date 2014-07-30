//
//  DreamEditViewController.swift
//  DreamOrient
//
//  Created by Richard Lee on 7/29/14.
//  Copyright (c) 2014 Weimed LLC (weimed.com). All rights reserved.
//

import UIKit
import CoreData

class DreamEditViewController: UIViewController {

    // Properties
    var managedObjectContext: NSManagedObjectContext?
    var dreamID: NSManagedObjectID?

    @IBOutlet var name: UITextField!
    @IBOutlet var credits: UITextField!

    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        // Initialize variables.
        println("Initialize Dream Edit View Controller")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Navigation Title
        self.navigationItem.title = "Dream Info"

        // Create a submit button in the navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveDream:")
    }

    func saveDream(barButtonItem: UIBarButtonItem) {
        // Check which button it is, if you have more than one button on the screen
        // you must check before taking necessary action
        if (true) {
            NSLog("Clicked 'Save' on the bar button")
            // No object id, then we have to create a new dream
            if (self.dreamID == nil) {
                self.createNewDreamWithName(name.text, paramCredits: credits.text.toInt())
            } else {
                //self.updateDreamWithName()
            }

            // Pop to the parent view
            self.navigationController.popViewControllerAnimated(true)
        }
    }

    override func viewWillAppear(animated: Bool) {
        // If we have the dream id then its in an edit mode, load the existing values
        if (self.dreamID != nil) {
            var error: NSError? = nil
            // TODO
            //
        } else { // Add mode clean our text view fields
            name.text = ""
            credits.text = ""
        }
    }

    func createNewDreamWithName(paramName: String, paramCredits: Int?) -> Bool {
        var success = false
        if (paramName.isEmpty) {
            NSLog("Name is mandatory.")
            return success
        }

        // Create a new dream which be allocated
        var newDream = NSEntityDescription.insertNewObjectForEntityForName("Dream", inManagedObjectContext: self.managedObjectContext) as Dream
        if (newDream == nil) {
            NSLog("Failed to create the new dream")
            return success
        }

        // assign values
        newDream.name = paramName
        if paramCredits {
            newDream.credits = paramCredits!
        } else {
            newDream.credits = 30
        }
        newDream.entityId = NSUUID.UUID().UUIDString

        // Save the new dream
        var savingError: NSError? = nil
        if (self.managedObjectContext!.save(&savingError)) {
            NSLog("New dream was created!")
            return success
        } else {
            NSLog("Failed to save the new dream, Error = %@", savingError!)
        }

        return success
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