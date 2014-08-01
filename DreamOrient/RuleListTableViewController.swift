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
    var dataFRC: NSFetchedResultsController?
    var actor: Actor?
    var dream: Dream?
    var creditsSum: Int = 0

    init(coder aDecoder: NSCoder!) {
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

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // If we got the dream then list the rules which related to the dream
        if self.dream {
            // Create the fetch request
            var fetchRequest = NSFetchRequest()

            // Create reference to the Rule entity
            fetchRequest.entity = NSEntityDescription.entityForName("Rule", inManagedObjectContext: self.managedObjectContext)

            // Set filter
            fetchRequest.predicate = NSPredicate(format:"dream.entityId == %@", self.dream!.entityId)

            // In what order you want your data to be fetched
            var sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchBatchSize = 20

            var error: NSError? = nil
            NSLog("%d entities found.", self.managedObjectContext!.countForFetchRequest(fetchRequest, error: &error))

            // Initialize a fetched results controller to efficiently manage the results
            NSFetchedResultsController.deleteCacheWithName("allRulesCache")
            dataFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "allRulesCache")

            // Notify the view controller when the fetched results change
            self.dataFRC!.delegate = self

            var fetchingError: NSError? = nil
            // Perform the fetch request
            if (self.dataFRC!.performFetch(&fetchingError)) {
                let sectionInfo = self.dataFRC!.sections[self.dataFRC!.sections.count - 1] as NSFetchedResultsSectionInfo
                NSLog("fetched rule count: \(sectionInfo.numberOfObjects)")
                NSLog("Successfully fetched data from Rule entity")
            } else {
                NSLog("Failed to fetch any data from the Rule entity")
            }

            // Create reference to the Actor entity
            // Fetch actor who a dream is in his list
            var fetchRequest2 = NSFetchRequest(entityName: "Actor")
            error = nil
            // Set filter
            fetchRequest2.predicate = NSPredicate(format:"dreams CONTAINS %@", self.dream!)

            // Set result sorter
            var sortDescriptor2 = NSSortDescriptor(key: "name" , ascending: false)
            fetchRequest2.sortDescriptors = [sortDescriptor2]

            // Execute fetch request
            var result = self.managedObjectContext!.executeFetchRequest(fetchRequest2, error:&error)
            if error { NSLog("%@", error!) }
            NSLog("fetched actor count: \(result.count)")
            self.actor = (result[result.count - 1] as Actor)
            NSLog("Fetched Actor for \(self.actor?.name) + \(self.actor?.credits) + \(self.actor?.entityId)")
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("View will be appear")
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        NSLog("View will be disappear")
        NSLog("Summary of credits: \(self.creditsSum)")

//        if self.actor {
//            // Update the credit of actorr
//            self.actor!.credits = self.creditsSum + self.actor!.credits.integerValue
//
//            if self.creditsSum != 0 {
//                // Save the change
//                var error: NSError? = nil
//                if (self.managedObjectContext!.save(&error)) {
//                    NSLog("Saved Actor for \(self.actor!.name) + \(self.actor!.credits) + \(self.actor!.entityId)")
//                } else {
//                    NSLog("Failed to save the Actor - %@", error!)
//                }
//            }
//        }
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
        return self.dataFRC!.sections.count
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let sectionInfo = self.dataFRC!.sections[section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        // Create a reusable table-view cell object located by its identifier
        var cell = tableView.dequeueReusableCellWithIdentifier("RuleCell", forIndexPath: indexPath) as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style:.Default, reuseIdentifier: "RuleCell")
        }

        // Get the rule object at the given index path in the fetch results
        var rule = self.dataFRC!.objectAtIndexPath(indexPath) as Rule

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
        var rule = self.dataFRC!.objectAtIndexPath(indexPath) as Rule

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
            self.managedObjectContext!.deleteObject(self.dataFRC!.objectAtIndexPath(indexPath) as NSManagedObject)
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

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

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
            viewController.dream = self.dream

            // Pass the NSManagedObjectContext
            viewController.managedObjectContext = self.managedObjectContext
        }
    }

}
