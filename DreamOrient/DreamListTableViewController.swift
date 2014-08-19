//
//  DreamListTableViewController.swift
//  DreamOrient
//
//  Created by Richard Lee on 7/28/14.
//  Copyright (c) 2014 Weimed LLC (weimed.com). All rights reserved.
//

import UIKit
import CoreData

class DreamListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // Properties
    var managedObjectContext: NSManagedObjectContext?
    var dreamEditViewController: DreamEditViewController?
    var dreamFRC: NSFetchedResultsController?
    // Define actorFRC only for update actor credits automatically
    var actorFRC: NSFetchedResultsController?

    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        NSLog("Initialize Dream List Table View Controller")

        // Get the application delegate and its managed object context
        if (self.managedObjectContext == nil) {
            self.managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).cdhelper.managedObjectContext
        }

        // Get the fetch result controller
        let entityDream: NSString = "Dream"
        dreamFRC = CoreDataUtils.getFetchedResultController(managedObjectContext: self.managedObjectContext!, entityName: entityDream, sortKey: "no", sortKey2: "name")
        // Notify the view controller when the fetched results change
        dreamFRC!.delegate = self

        var fetchingError: NSError? = nil
        // Perform the fetch request
        if (dreamFRC!.performFetch(&fetchingError)) {
            NSLog("Successfully fetched data from Dream entity")
        } else {
            NSLog("Failed to fetch any data from the Dream entity")
        }

        // Get the fetch result controller
        let entityActor: NSString = "Actor"
        actorFRC = CoreDataUtils.getFetchedResultController(managedObjectContext: self.managedObjectContext!, entityName: entityActor, sortKey: "name")
        // Notify the view controller when the fetched results change
        actorFRC!.delegate = self

        fetchingError = nil
        // Perform the fetch request
        if (actorFRC!.performFetch(&fetchingError)) {
            NSLog("Successfully fetched data from Actor entity")
        } else {
            NSLog("Failed to fetch any data from the Actor entity")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSLog("Rule List Table View Loaded")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        // Display toolbar
        self.navigationController.setToolbarHidden(false, animated: true)
    }

    override func viewWillDisappear(animated: Bool) {
        // Hide toolbar
        self.navigationController.setToolbarHidden(true, animated: true)
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
        return dreamFRC!.sections.count
    }

    // The number of rows in a given section of a table view
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let sectionInfo = dreamFRC!.sections[section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    // Insert in a particular location of the table view for a given section/row location
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        // Create a reusable table-view cell object located by its identifier
        var cell = tableView.dequeueReusableCellWithIdentifier("DreamCell", forIndexPath: indexPath) as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style:.Default, reuseIdentifier: "DreamCell")
        }

        // Get the dream object at the given index path in the fetch results
        var dream = dreamFRC!.objectAtIndexPath(indexPath) as Dream

        // Display text for the cell view
        cell.textLabel.text = dream.name
        cell.detailTextLabel.text = "\(dream.gains)/\(dream.credits)"

        // Set the accessory view to be a clickable button - commented, since we can set it with IB
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }

    override func tableView(tableView: UITableView!, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath!) {
        if (tableView.isEqual(self.tableView)) {
            NSLog("Cell \(indexPath.row) accessory button in Section \(indexPath.section) is tapped")
        }
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if (tableView.isEqual(self.tableView)) {
            NSLog("Cell \(indexPath.row) in Section \(indexPath.section) is selected")
        }
    }

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
            self.managedObjectContext!.deleteObject(dreamFRC!.objectAtIndexPath(indexPath) as NSManagedObject)
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
        // Get the dream object at the given index path in the fetch results
        var dreamFromIndexPath = dreamFRC!.objectAtIndexPath(fromIndexPath) as Dream
        dreamFromIndexPath.no = toIndexPath.row
        // Get the dream object at the given index path in the fetch results
        var dreamToIndexPath = dreamFRC!.objectAtIndexPath(toIndexPath) as Dream
        dreamToIndexPath.no = fromIndexPath.row
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
        if (segue.identifier? == "dreamAdd") {
            NSLog("Clicked 'Add' on the bar button")
            let viewController = segue.destinationViewController as DreamEditViewController

            // Set the dream id to ZERO when creating a new dream
            viewController.dreamID = nil

            // Pass the NSManagedObjectContext
            viewController.managedObjectContext = self.managedObjectContext
        } else if (segue.identifier? == "dreamEdit"){
            NSLog("Edit Dream")
            let viewController = segue.destinationViewController as DreamEditViewController

            // Pass the dreamID when editing the dream
            var dream = dreamFRC!.objectAtIndexPath(self.tableView.indexPathForCell(sender as UITableViewCell)) as Dream
            viewController.dreamID = dream.objectID

            // Pass the NSManagedObjectContext
            viewController.managedObjectContext = self.managedObjectContext
        } else if (segue.identifier? == "ruleList") {
            NSLog("Clicked 'Accessory' on the list")
            let viewController = segue.destinationViewController as RuleListTableViewController

            // Pass the dreamID to the rule list
            var dream = dreamFRC!.objectAtIndexPath(self.tableView.indexPathForCell(sender as UITableViewCell)) as Dream
            viewController.dreamID = dream.objectID

            // Pass the NSManagedObjectContext
            viewController.managedObjectContext = self.managedObjectContext
        }
    }

}
