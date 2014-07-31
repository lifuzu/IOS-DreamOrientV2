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
    var dream: Dream?

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
            fetchRequest.predicate = NSPredicate(format:"ANY dream.entityId like %@", self.dream!.entityId)

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
        }

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSLog("View will be appear")
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

        // Display text for the cell view
        cell.textLabel.text = rule.name
        //cell.detailTextLabel.text = "\(rule.credits)"

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
