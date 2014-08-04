//
//  CoreDataUtils.swift
//  DreamOrient
//
//  Created by Richard Lee on 8/3/14.
//  Copyright (c) 2014 Weimed LLC (weimed.com). All rights reserved.
//

import CoreData

class CoreDataUtils: NSObject, NSFetchedResultsControllerDelegate{

    class func getFetchedResultController(#managedObjectContext: NSManagedObjectContext, entityName paramEntityName: String, sortKey paramSortKey: String) -> NSFetchedResultsController {
        let cacheName = "all" + paramEntityName + "sCache"
        // Initialize a fetched results controller to efficiently manage the results
        NSFetchedResultsController.deleteCacheWithName(cacheName)
        var fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(managedObjectContext: managedObjectContext, entityName: paramEntityName, sortKey: paramSortKey), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: cacheName)
        return fetchedResultController
    }

    class func taskFetchRequest(#managedObjectContext: NSManagedObjectContext, entityName paramEntityName: String, sortKey paramSortKey: String) -> NSFetchRequest {
        // Create the fetch request
        var fetchRequest = NSFetchRequest()

        // Create reference to the Dream entity
        fetchRequest.entity = NSEntityDescription.entityForName(paramEntityName, inManagedObjectContext: managedObjectContext)

        // In what order you want your data to be fetched
        var sortDescriptor = NSSortDescriptor(key: paramSortKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20

        return fetchRequest
    }
}