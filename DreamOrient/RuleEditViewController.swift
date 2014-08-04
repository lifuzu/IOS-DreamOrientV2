//
//  RuleEditViewController.swift
//  DreamOrient
//
//  Created by Richard Lee on 7/31/14.
//  Copyright (c) 2014 Weimed LLC (weimed.com). All rights reserved.
//

import UIKit
import CoreData

class RuleEditViewController: UIViewController {

    // Properties
    var managedObjectContext: NSManagedObjectContext?
    var dream: Dream?
    var dreamID: NSManagedObjectID?
    var ruleID: NSManagedObjectID?

    @IBOutlet var name: UITextField!
    @IBOutlet var credits: UITextField!

    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        // Initialize variables.
        println("Initialize Rule Edit View Controller")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Navigation Title
        self.navigationItem.title = "Rule Info"

        // Create a submit button in the navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveRule:")
    }

    func saveRule(barButtonItem: UIBarButtonItem) {
        // Check which button it is, if you have more than one button on the screen
        // you must check before taking necessary action
        if (true) {
            NSLog("Clicked 'Save' on the bar button")
            // No object id, then we have to create a new dream
            if (self.ruleID == nil) {
                self.createNewRuleWithName(name.text, paramCredits: credits.text.toInt())
            } else {
                //self.updateRuleWithName()
            }

            // Pop to the parent view
            self.navigationController.popViewControllerAnimated(true)
        }
    }

    override func viewWillAppear(animated: Bool) {
        // If we have the rule id then its in an edit mode, load the existing values
        if (self.ruleID != nil) {
            var error: NSError? = nil
            // TODO
            //
        } else { // Add mode clean our text view fields
            name.text = ""
            credits.text = ""
        }
    }

    func createNewRuleWithName(paramName: String, paramCredits: Int?) -> Bool {
        var success = false
        if (paramName.isEmpty) {
            NSLog("Name is mandatory.")
            return success
        }

        // Create a new rule which be allocated
        var newItem = NSEntityDescription.insertNewObjectForEntityForName("Rule", inManagedObjectContext: self.managedObjectContext) as Rule
        if (newItem == nil) {
            NSLog("Failed to create the new rule")
            return success
        }

        // assign values
        newItem.name = paramName
        if paramCredits {
            newItem.credits = paramCredits!
        } else {
            newItem.credits = 3
        }
        newItem.desc = "\(newItem.credits)"
        newItem.entityId = NSUUID.UUID().UUIDString
        newItem.createdAt = NSDate.date()
        newItem.modifiedAt = newItem.createdAt

        // Get the existing object according to the ID
        var error: NSError? = nil
        var dream = self.managedObjectContext!.existingObjectWithID(self.dreamID, error: &error) as Dream
        if (dream == nil) {
            NSLog("Failed to get the existing dream according to the dreamID")
            abort()
        }
        // setup relationship with dream
        newItem.dream = dream

        // Save the new rule
        var savingError: NSError? = nil
        if (self.managedObjectContext!.save(&savingError)) {
            NSLog("New rule was created!")
            return success
        } else {
            NSLog("Failed to save the new rule, Error = %@", savingError!)
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
