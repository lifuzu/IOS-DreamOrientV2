//
//  RuleListTableViewController.swift
//  DreamOrient
//
//  Created by Richard Lee on 7/30/14.
//  Copyright (c) 2014 Weimed LLC (weimed.com). All rights reserved.
//

import UIKit
import CoreData

class RuleListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // Properties
    var managedObjectContext: NSManagedObjectContext?
    var ruleFRC: NSFetchedResultsController?
    var actor: Actor?
    var dreamID: NSManagedObjectID?
    var creditsSum: Int = 0

    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        NSLog("Initialize Rule List Table View Controller")

        // Get the application delegate and its managed object context
        if (self.managedObjectContext == nil) {
            self.managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).cdhelper.managedObjectContext
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSLog("Rule List Table View Loaded")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // If we got the dream then list the rules which related to the dream
        if self.dreamID != nil {
            var error: NSError? = nil

            // Get the existing object according to the ID
            var dream = self.managedObjectContext!.existingObjectWithID(self.dreamID, error: &error) as Dream
            if (dream == nil) {
                NSLog("Failed to get the existing dream according to the dreamID")
                abort()
            }

            // Get the fetch result controller with predicate
            let entityRule: NSString = "Rule"
            ruleFRC = CoreDataUtils.getFetchedResultControllerWithPredicate(managedObjectContext: self.managedObjectContext!, entityName: entityRule, sortKey: "no", predicateKey: "dream.entityId == %@", predicateValue: dream.entityId)
            // Notify the view controller when the fetched results change
            ruleFRC!.delegate = self

            var fetchingError: NSError? = nil
            // Perform the fetch request
            if (ruleFRC!.performFetch(&fetchingError)) {
                NSLog("Successfully fetched data from Rule entity")
            } else {
                NSLog("Failed to fetch any data from the Rule entity")
            }

            // Create reference to the Actor entity
            // Fetch actor who a dream is in his list
            let entityActor: NSString = "Actor"
            var fetchRequest2 = NSFetchRequest(entityName: entityActor)
            error = nil
            // Set filter
            fetchRequest2.predicate = NSPredicate(format:"dreams CONTAINS %@", dream)

            // Set result sorter
            var sortDescriptor2 = NSSortDescriptor(key: "name" , ascending: false)
            fetchRequest2.sortDescriptors = [sortDescriptor2]

            // Execute fetch request
            var result = self.managedObjectContext!.executeFetchRequest(fetchRequest2, error:&error)
            if error != nil { NSLog("%@", error!) }
            NSLog("fetched actor count: \(result.count)")
            self.actor = (result[result.count - 1] as Actor)
            NSLog("Fetched Actor for \(self.actor?.name) + \(self.actor?.credits) + \(self.actor?.entityId)")
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Display toolbar
        self.navigationController.setToolbarHidden(false, animated: true)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Hide toolbar
        self.navigationController.setToolbarHidden(true, animated: true)
    }

    override func willMoveToParentViewController(parent: UIViewController!) {
        NSLog("Summary of credits: \(self.creditsSum)")

        if self.dreamID != nil {
            var error: NSError? = nil
            // Get the existing object according to the ID
            var dream = self.managedObjectContext!.existingObjectWithID(self.dreamID, error: &error) as Dream
            if (dream == nil) {
                NSLog("Failed to get the existing dream according to the dreamID")
                abort()
            }
            // Update the gains of dream
            dream.gains = self.creditsSum + dream.gains.integerValue

            if self.creditsSum != 0 {
                // Save the change
                var error: NSError? = nil
                if (self.managedObjectContext!.save(&error)) {
                    NSLog("Saved gains for \(dream.name) + \(dream.gains) + \(dream.credits) + \(dream.entityId)")
                } else {
                    NSLog("Failed to save the Actor - %@", error!)
                }
            }
        }
    }

    // Notify the receiver that the fetched results controller has completed processing
    // of one or more changes due to an add, remove, move, or update
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // Return the number of sections.
        return self.ruleFRC!.sections.count
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let sectionInfo = self.ruleFRC!.sections[section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        // Create a reusable table-view cell object located by its identifier
        var cell = tableView.dequeueReusableCellWithIdentifier("RuleCell", forIndexPath: indexPath) as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style:.Default, reuseIdentifier: "RuleCell")
        }

        // Get the rule object at the given index path in the fetch results
        var rule = self.ruleFRC!.objectAtIndexPath(indexPath) as Rule

        // Display text for the cell view, and set cell unchecked
        cell.textLabel.text = rule.name
        cell.detailTextLabel.text = "\(rule.credits)"

        // Initially set cell unselected and set the sum of credits is 0
        cell.accessoryType = UITableViewCellAccessoryType.None
        self.creditsSum = 0

        return cell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        // Get the cell selected
        var cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell

        // Get the rule object at the given index path in the fetch results
        var rule = self.ruleFRC!.objectAtIndexPath(indexPath) as Rule

        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            cell.accessoryType = UITableViewCellAccessoryType.None
            self.creditsSum -= rule.credits.integerValue
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.creditsSum += rule.credits.integerValue
        }
    }

//    override func tableView(tableView: UITableView!, didDeselectRowAtIndexPath indexPath: NSIndexPath!) {
//        // Get the cell deselected
//        var cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell
//        cell.accessoryType = UITableViewCellAccessoryType.None
//    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            // Remove the data source from database
            self.managedObjectContext!.deleteObject(self.ruleFRC!.objectAtIndexPath(indexPath) as NSManagedObject)
            // Save the change
            var error: NSError? = nil
            if (self.managedObjectContext!.save(&error)) {
                NSLog("Successfully save the change.")
            } else {
                NSLog("Failed to save the change - %@", error!)
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {
        // Get the object at the given index path in the fetch results
        var ruleFromIndexPath = ruleFRC!.objectAtIndexPath(fromIndexPath) as Rule
        ruleFromIndexPath.no = toIndexPath.row
        // Get the object at the given index path in the fetch results
        var ruleToIndexPath = ruleFRC!.objectAtIndexPath(toIndexPath) as Rule
        ruleToIndexPath.no = fromIndexPath.row
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue.identifier? == "ruleAdd") {
            NSLog("Clicked 'Add' on the bar button")
            let viewController = segue.destinationViewController as RuleEditViewController

            // Set the rule id to ZERO when creating a new rule
            viewController.ruleID = nil

            // pass dream to edit controller, to setup the relationship
            viewController.dreamID = self.dreamID

            // Pass the NSManagedObjectContext
            viewController.managedObjectContext = self.managedObjectContext
        }
    }

}
