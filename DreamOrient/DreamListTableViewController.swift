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
    var dataFRC: NSFetchedResultsController?
    var dreamEditViewController: DreamEditViewController?

    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        NSLog("Initialize Dream List Table View Controller")

        // Get the application delegate and its managed object context
        if (self.managedObjectContext == nil) {
            self.managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).cdhelper.managedObjectContext
        }

        // Create the fetch request
        var fetchRequest = NSFetchRequest()

        // Create reference to the Dream entity
        fetchRequest.entity = NSEntityDescription.entityForName("Dream", inManagedObjectContext: self.managedObjectContext)

        // In what order you want your data to be fetched
        var sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20

        // Initialize a fetched results controller to efficiently manage the results
        NSFetchedResultsController.deleteCacheWithName("allDreamsCache")
        dataFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "allDreamsCache")

        // Notify the view controller when the fetched results change
        self.dataFRC!.delegate = self

        var fetchingError: NSError? = nil
        // Perform the fetch request
        if (self.dataFRC!.performFetch(&fetchingError)) {
            NSLog("Successfully fetched data from Dream entity")
        } else {
            NSLog("Failed to fetch any data from the Dream entity")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSLog("Rule List Table View Loaded")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    // The number of rows in a given section of a table view
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let sectionInfo = self.dataFRC!.sections[section] as NSFetchedResultsSectionInfo
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
        var dream = self.dataFRC!.objectAtIndexPath(indexPath) as Dream

        // Display text for the cell view
        cell.textLabel.text = dream.name
        cell.detailTextLabel.text = "\(dream.credits)"

        // Set the accessory view to be a clickable button - commented, since we can set it with IB
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }

    override func tableView(tableView: UITableView!, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath!) {
        if (tableView.isEqual(self.tableView)) {
            NSLog("Cell \(indexPath.row) accessory button in Section \(indexPath.section) is tapped")

            // Let go ahead and allow list the rules of this dream
            //self.listRules(indexPath)
        }
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
        } else if (segue.identifier? == "ruleList") {
            NSLog("Clicked 'Accessory' on the list")
            let viewController = segue.destinationViewController as RuleListTableViewController

            // Pass the dream to the rule list
            var dream = self.dataFRC!.objectAtIndexPath(self.tableView.indexPathForCell(sender as UITableViewCell)) as Dream
            viewController.dream = dream

            // Pass the NSManagedObjectContext
            viewController.managedObjectContext = self.managedObjectContext
        }
    }

}
