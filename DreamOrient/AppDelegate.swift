//
//  AppDelegate.swift
//  DreamOrient
//
//  Created by Richard Lee on 7/23/14.
//  Copyright (c) 2014 Weimed LLC (weimed.com). All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
//        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        // Override point for customization after application launch.
//        self.window!.backgroundColor = UIColor.whiteColor()
//        self.window!.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // Saves changes in the application's managed object context before the application terminates.
        self.cdhelper.saveContext()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.demoDream()
        self.demoRule()
        self.demoActor()
        self.demoRelationship()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.cdhelper.saveContext()
    }
    
    // #pragma mark - Core Data Helper
    
    var cdstore: CoreDataStore {
        if !_cdstore {
            _cdstore = CoreDataStore()
        }
        return _cdstore!
    }
    var _cdstore: CoreDataStore? = nil
    
    var cdhelper: CoreDataHelper {
        if !_cdhelper {
            _cdhelper = CoreDataHelper()
        }
        return _cdhelper!
    }
    var _cdhelper: CoreDataHelper? = nil

    /*func saveContext () {
        var error: NSError? = nil
        let managedObjectContext = self.managedObjectContext
        if managedObjectContext != nil {
            if managedObjectContext.hasChanges && !managedObjectContext.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }

    // #pragma mark - Core Data stack

    // Returns the managed object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    var managedObjectContext: NSManagedObjectContext {
        if !_managedObjectContext {
            let coordinator = self.persistentStoreCoordinator
            if coordinator != nil {
                _managedObjectContext = NSManagedObjectContext()
                _managedObjectContext!.persistentStoreCoordinator = coordinator
            }
        }
        return _managedObjectContext!
    }
    var _managedObjectContext: NSManagedObjectContext? = nil

    // Returns the managed object model for the application.
    // If the model doesn't already exist, it is created from the application's model.
    var managedObjectModel: NSManagedObjectModel {
        if !_managedObjectModel {
            let modelURL = NSBundle.mainBundle().URLForResource("DreamOrient", withExtension: "momd")
            _managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)
        }
        return _managedObjectModel!
    }
    var _managedObjectModel: NSManagedObjectModel? = nil

    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.
    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        if !_persistentStoreCoordinator {
            let storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("DreamOrient.sqlite")
            var error: NSError? = nil
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            if _persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error) == nil {
                /*
                Replace this implementation with code to handle the error appropriately.

                abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                Typical reasons for an error here include:
                * The persistent store is not accessible;
                * The schema for the persistent store is incompatible with current managed object model.
                Check the error message to determine what the actual problem was.


                If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

                If you encounter schema incompatibility errors during development, you can reduce their frequency by:
                * Simply deleting the existing store:
                NSFileManager.defaultManager().removeItemAtURL(storeURL, error: nil)

                * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
                [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true}

                Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

                */
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
        return _persistentStoreCoordinator!
    }
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil

    // #pragma mark - Application's Documents directory
                                    
    // Returns the URL to the application's Documents directory.
    var applicationDocumentsDirectory: NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex-1] as NSURL
    }*/

    func demoDream() {
        var newItemNames = ["Apples", "Milk", "Bread", "Cheese", "Sausages", "Butter", "Orange Juice", "Cereal", "Coffee", "Eggs", "Tomatoes", "Fish"]
        
        // add dreams
        NSLog(" ======== Insert ======== ")
        
        for newItemName in newItemNames {
            var newItem: Dream = NSEntityDescription.insertNewObjectForEntityForName("Dream", inManagedObjectContext: self.cdhelper.backgroundContext) as Dream
            
            newItem.name = newItemName
            newItem.credits = 20
            newItem.entityId = NSUUID.UUID().UUIDString
            NSLog("Inserted New Dream for \(newItem.name) + \(newItem.credits) + \(newItem.entityId) ")
        }
        
        self.cdhelper.saveContext(self.cdhelper.backgroundContext)
        
        //fetch dreams
        NSLog(" ======== Fetch ======== ")
        
        var error: NSError? = nil
        var fReq: NSFetchRequest = NSFetchRequest(entityName: "Dream")
        
        // set filter
        fReq.predicate = NSPredicate(format:"name CONTAINS 'B' ")
        
        // set result sorter
        var sorter: NSSortDescriptor = NSSortDescriptor(key: "name" , ascending: false)
        fReq.sortDescriptors = [sorter]
        
        var result = self.cdhelper.managedObjectContext.executeFetchRequest(fReq, error:&error)
        for resultItem : AnyObject in result {
            var newItem = resultItem as Dream
            NSLog("Fetched Dream for \(newItem.name) + \(newItem.credits) + \(newItem.entityId)")
        }
        
        //delete dreams
        NSLog(" ======== Delete ======== ")
        
        fReq = NSFetchRequest(entityName: "Dream")
        result = self.cdhelper.backgroundContext.executeFetchRequest(fReq, error:&error)
        
        for resultItem : AnyObject in result {
            var newItem = resultItem as Dream
            NSLog("Deleted Dream for \(newItem.name) + \(newItem.credits) ")
            self.cdhelper.backgroundContext.deleteObject(newItem)
        }
        
        self.cdhelper.saveContext(self.cdhelper.backgroundContext)
        
        NSLog(" ======== Check Delete ======== ")
        
        result = self.cdhelper.managedObjectContext.executeFetchRequest(fReq, error:&error)
        if result.isEmpty {
            NSLog("Deleted All Dreams")
        }
        else{
            for resultItem : AnyObject in result {
                var newItem = resultItem as Dream
                NSLog("Fetched Error Dream for \(newItem.name) ")
            }
        }
    }

    func demoRule() {
        var newItemNames = ["Apples", "Milk", "Bread", "Cheese", "Sausages", "Butter", "Orange Juice", "Cereal", "Coffee", "Eggs", "Tomatoes", "Fish"]
        
        // add rules
        NSLog(" ======== Insert ======== ")
        
        for newItemName in newItemNames {
            var newItem: Rule = NSEntityDescription.insertNewObjectForEntityForName("Rule", inManagedObjectContext: self.cdhelper.backgroundContext) as Rule
            
            newItem.name = newItemName
            newItem.credits = 2
            newItem.desc = newItemName + "\(newItem.credits)"
            newItem.entityId = NSUUID.UUID().UUIDString
            newItem.createdAt = NSDate.date()
            newItem.modifiedAt = newItem.createdAt
            NSLog("Inserted New Rule for \(newItem.name) + \(newItem.credits) + \(newItem.entityId)")
        }
        
        self.cdhelper.saveContext(self.cdhelper.backgroundContext)
        
        //fetch rules
        NSLog(" ======== Fetch ======== ")
        
        var error: NSError? = nil
        var fReq: NSFetchRequest = NSFetchRequest(entityName: "Rule")
        
        // set filter
        fReq.predicate = NSPredicate(format:"name CONTAINS 'B' ")
        
        // set result sorter
        var sorter: NSSortDescriptor = NSSortDescriptor(key: "name" , ascending: false)
        fReq.sortDescriptors = [sorter]
        
        var result = self.cdhelper.managedObjectContext.executeFetchRequest(fReq, error:&error)
        for resultItem : AnyObject in result {
            var newItem = resultItem as Rule
            NSLog("Fetched Rule for \(newItem.name) + \(newItem.credits) + \(newItem.entityId)")
        }
        
        //delete rules
        NSLog(" ======== Delete ======== ")
        
        fReq = NSFetchRequest(entityName: "Rule")
        result = self.cdhelper.backgroundContext.executeFetchRequest(fReq, error:&error)
        
        for resultItem : AnyObject in result {
            var newItem = resultItem as Rule
            NSLog("Deleted Rule for \(newItem.name) + \(newItem.credits) ")
            self.cdhelper.backgroundContext.deleteObject(newItem)
        }
        
        self.cdhelper.saveContext(self.cdhelper.backgroundContext)
        
        NSLog(" ======== Check Delete ======== ")
        
        result = self.cdhelper.managedObjectContext.executeFetchRequest(fReq, error:&error)
        if result.isEmpty {
            NSLog("Deleted All Rules")
        }
        else{
            for resultItem : AnyObject in result {
                var newItem = resultItem as Rule
                NSLog("Fetched Error Rule for \(newItem.name) ")
            }
        }
    }

    func demoActor() {
        var newItemNames = ["Apples", "Milk", "Bread", "Cheese", "Sausages", "Butter", "Orange Juice", "Cereal", "Coffee", "Eggs", "Tomatoes", "Fish"]
        
        // add actors
        NSLog(" ======== Insert ======== ")
        
        for newItemName in newItemNames {
            var newItem: Actor = NSEntityDescription.insertNewObjectForEntityForName("Actor", inManagedObjectContext: self.cdhelper.backgroundContext) as Actor
            
            newItem.name = newItemName
            newItem.credits = 5
            newItem.entityId = NSUUID.UUID().UUIDString
            NSLog("Inserted New Actor for \(newItem.name) + \(newItem.credits) + \(newItem.entityId)")
        }
        
        self.cdhelper.saveContext(self.cdhelper.backgroundContext)
        
        //fetch actors
        NSLog(" ======== Fetch ======== ")
        
        var error: NSError? = nil
        var fReq: NSFetchRequest = NSFetchRequest(entityName: "Actor")
        
        // set filter
        fReq.predicate = NSPredicate(format:"name CONTAINS 'B' ")
        
        // set result sorter
        var sorter: NSSortDescriptor = NSSortDescriptor(key: "name" , ascending: false)
        fReq.sortDescriptors = [sorter]
        
        var result = self.cdhelper.managedObjectContext.executeFetchRequest(fReq, error:&error)
        for resultItem : AnyObject in result {
            var newItem = resultItem as Actor
            NSLog("Fetched Actor for \(newItem.name) + \(newItem.credits) + \(newItem.entityId)")
        }
        
        //delete actors
        NSLog(" ======== Delete ======== ")
        
        fReq = NSFetchRequest(entityName: "Actor")
        result = self.cdhelper.backgroundContext.executeFetchRequest(fReq, error:&error)
        
        for resultItem : AnyObject in result {
            var newItem = resultItem as Actor
            NSLog("Deleted Actor for \(newItem.name) + \(newItem.credits) ")
            self.cdhelper.backgroundContext.deleteObject(newItem)
        }
        
        self.cdhelper.saveContext(self.cdhelper.backgroundContext)
        
        NSLog(" ======== Check Delete ======== ")
        
        result = self.cdhelper.managedObjectContext.executeFetchRequest(fReq, error:&error)
        if result.isEmpty {
            NSLog("Deleted All Rules")
        }
        else{
            for resultItem : AnyObject in result {
                var newItem = resultItem as Actor
                NSLog("Fetched Error Actor for \(newItem.name) ")
            }
        }
    }

    func demoRelationship() {

        // create two rules
        var newRule1: Rule = NSEntityDescription.insertNewObjectForEntityForName("Rule", inManagedObjectContext: self.cdhelper.managedObjectContext) as Rule

        newRule1.name = "one rule"
        newRule1.credits = 2
        newRule1.desc = newRule1.name + "\(newRule1.credits)"
        newRule1.entityId = NSUUID.UUID().UUIDString
        newRule1.createdAt = NSDate.date()
        newRule1.modifiedAt = newRule1.createdAt
        NSLog("Created One New Rule for \(newRule1.name) + \(newRule1.credits) + \(newRule1.entityId)")
        self.cdhelper.saveContext(self.cdhelper.managedObjectContext)

        var newRule2: Rule = NSEntityDescription.insertNewObjectForEntityForName("Rule", inManagedObjectContext: self.cdhelper.managedObjectContext) as Rule

        newRule2.name = "another rule"
        newRule2.credits = 3
        newRule2.desc = newRule2.name + "\(newRule2.credits)"
        newRule2.entityId = NSUUID.UUID().UUIDString
        newRule2.createdAt = NSDate.date()
        newRule2.modifiedAt = newRule2.createdAt
        NSLog("Created Another New Rule for \(newRule2.name) + \(newRule2.credits) + \(newRule2.entityId)")
        self.cdhelper.saveContext(self.cdhelper.managedObjectContext)

        var newRule3: Rule = NSEntityDescription.insertNewObjectForEntityForName("Rule", inManagedObjectContext: self.cdhelper.managedObjectContext) as Rule
        
        newRule3.name = "another rule"
        newRule3.credits = 4
        newRule3.desc = newRule3.name + "\(newRule3.credits)"
        newRule3.entityId = NSUUID.UUID().UUIDString
        newRule3.createdAt = NSDate.date()
        newRule3.modifiedAt = newRule3.createdAt
        NSLog("Created Another New Rule for \(newRule3.name) + \(newRule3.credits) + \(newRule3.entityId)")
        self.cdhelper.saveContext(self.cdhelper.managedObjectContext)

        // create a dream
        var newDream: Dream = NSEntityDescription.insertNewObjectForEntityForName("Dream", inManagedObjectContext: self.cdhelper.managedObjectContext) as Dream

        newDream.name = "anew dream"
        newDream.credits = 20
        newDream.entityId = NSUUID.UUID().UUIDString
        NSLog("Created A New Dream for \(newDream.name) + \(newDream.credits) + \(newDream.entityId) ")
        self.cdhelper.saveContext(self.cdhelper.managedObjectContext)

        // setup a relationship
        newDream.mutableSetValueForKey("rules").removeAllObjects()
        //newDream.mutableSetValueForKey("rules").addObject(newRule1)
        //self.cdhelper.saveContext(self.cdhelper.managedObjectContext)

        //newDream.mutableSetValueForKey("rules").removeObject(newRule1)
        //newDream.rules.addObjectsFromArray([newRule1, newRule2])
        newDream.mutableSetValueForKey("rules").addObjectsFromArray([newRule1, newRule3])
        self.cdhelper.saveContext(self.cdhelper.managedObjectContext)

        // check the relationship
        NSLog("Relationship count: \(newDream.rules.count)")
        for rule : AnyObject in newDream.rules {
            let ruleItem = rule as Rule
            NSLog("Check the relationship: \(ruleItem.name)")
        }

        // create another dream
        var newDream2: Dream = NSEntityDescription.insertNewObjectForEntityForName("Dream", inManagedObjectContext: self.cdhelper.managedObjectContext) as Dream
        
        newDream2.name = "another dream"
        newDream2.credits = 30
        newDream2.entityId = NSUUID.UUID().UUIDString
        NSLog("Created Aother Dream for \(newDream2.name) + \(newDream2.credits) + \(newDream2.entityId) ")
        self.cdhelper.saveContext(self.cdhelper.managedObjectContext)
        
        // setup a relationship
        newDream2.mutableSetValueForKey("rules").removeAllObjects()
        //newDream2.rules.addObject(newRule2)
        newDream2.mutableSetValueForKey("rules").addObject(newRule2)
        self.cdhelper.saveContext(self.cdhelper.managedObjectContext)

        // check the relationship
        NSLog("Relationship count: \(newDream2.rules.count)")
        for rule : AnyObject in newDream2.rules {
            let ruleItem = rule as Rule
            NSLog("Check the relationship: \(ruleItem.name)")
        }

        // create an actor
        var newActor: Actor = NSEntityDescription.insertNewObjectForEntityForName("Actor", inManagedObjectContext: self.cdhelper.managedObjectContext) as Actor
        newActor.name = "anew Actor"
        newActor.credits = 50
        newActor.entityId = NSUUID.UUID().UUIDString
        NSLog("Create anew Actor for \(newActor.name) + \(newActor.credits) + \(newActor.entityId)")
        self.cdhelper.saveContext(self.cdhelper.managedObjectContext)

        // setup a relationship between actor and dreams
        newActor.dreams.removeAllObjects()
        //newActor.dreams.addObject(newDream2)
        newActor.mutableSetValueForKey("dreams").addObject(newDream2)
        self.cdhelper.saveContext(self.cdhelper.managedObjectContext)

        var fReq: NSFetchRequest = NSFetchRequest(entityName: "Rule")
        var error: NSError? = nil
        // set filter
        //let stringDreamNameBegin = "anew dream"
        //fReq.predicate = NSPredicate(format:"ANY dream.name like 'anew dream'")

        // set result sorter
        var sorter: NSSortDescriptor = NSSortDescriptor(key: "name" , ascending: false)
        fReq.sortDescriptors = [sorter]

        var result = self.cdhelper.backgroundContext.executeFetchRequest(fReq, error:&error)
        NSLog("fetched count: \(result.count)")
        for resultItem : AnyObject in result {
            var newItem = resultItem as Rule
            NSLog("Fetched Rule for \(newItem.name) + \(newItem.credits) + \(newItem.entityId)")
            /*NSLog("Relationship count: \(newItem.rules.count)")
            for rule : AnyObject in newItem.rules {
                let ruleItem = rule as Rule
                NSLog("Check the relationship: \(ruleItem.name)")
            }*/
        }

        fReq = NSFetchRequest(entityName: "Dream")
        error = nil
        // set filter
        let stringDreamNameBegin = "anew dream"
        fReq.predicate = NSPredicate(format:"ANY name like %@", stringDreamNameBegin)

        // set result sorter
        sorter = NSSortDescriptor(key: "name" , ascending: false)
        fReq.sortDescriptors = [sorter]

        result = self.cdhelper.backgroundContext.executeFetchRequest(fReq, error:&error)
        NSLog("fetched dream count: \(result.count)")
        for resultItem : AnyObject in result {
            var newItem = resultItem as Dream
            NSLog("Fetched Rule for \(newItem.name) + \(newItem.credits) + \(newItem.entityId)")
            NSLog("Relationship to rule count: \(newItem.rules.count)")
            for rule : AnyObject in newItem.rules {
            let ruleItem = rule as Rule
            NSLog("Check the relationship: \(ruleItem.name) + \(ruleItem.credits) + \(ruleItem.entityId)")
            }
        }

        fReq = NSFetchRequest(entityName: "Actor")
        error = nil
        // set filter
        let stringActorNameBegin = "anew actor"
        fReq.predicate = NSPredicate(format:"ANY name like[c] %@", stringActorNameBegin)
        
        // set result sorter
        sorter = NSSortDescriptor(key: "name" , ascending: false)
        fReq.sortDescriptors = [sorter]

        result = self.cdhelper.backgroundContext.executeFetchRequest(fReq, error:&error)
        NSLog("fetched actor count: \(result.count)")
        for resultItem : AnyObject in result {
            var newItem = resultItem as Actor
            NSLog("Fetched Actor for \(newItem.name) + \(newItem.credits) + \(newItem.entityId)")
            NSLog("Relationship to dreams count: \(newItem.dreams.count)")
            for rule : AnyObject in newItem.dreams {
                let ruleItem = rule as Dream
                NSLog("Check the relationship to dreams: \(ruleItem.name) + \(ruleItem.credits) + \(ruleItem.entityId)")
            }
        }

        // Fetch rules where dream is same one
        fReq = NSFetchRequest(entityName: "Rule")
        error = nil
        // Set filter
        NSLog("newDream.entityId = %@", newDream.entityId)
        fReq.predicate = NSPredicate(format:"ANY dream.entityId like %@", newDream.entityId)

        // Set result sorter
        sorter = NSSortDescriptor(key: "name" , ascending: false)
        fReq.sortDescriptors = [sorter]

        result = self.cdhelper.backgroundContext.executeFetchRequest(fReq, error:&error)
        if error { NSLog("%@", error!) }
        NSLog("fetched rule count: \(result.count)")
        for resultItem : AnyObject in result {
            var newItem = resultItem as Rule
            NSLog("Fetched Rule for \(newItem.name) + \(newItem.credits) + \(newItem.entityId)")
        }

        var predicate = NSPredicate(format:"dream.entityId like %@", newDream.entityId)
        var result2 = result.filter{ predicate.evaluateWithObject($0) }
        NSLog("fetched rule count: \(result2.count)")
        for resultItem : AnyObject in result2 {
            var newItem = resultItem as Rule
            NSLog("Fetched Rule for \(newItem.name) + \(newItem.credits) + \(newItem.entityId)")
        }
    }
}

