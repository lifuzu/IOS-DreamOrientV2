//
//  Rule.swift
//  DreamOrient
//
//  Created by Richard Lee on 7/26/14.
//  Copyright (c) 2014 Weimed LLC (weimed.com). All rights reserved.
//

import Foundation
import CoreData

@objc(Rule)
class Rule: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var credits: NSNumber
    @NSManaged var desc: String
    @NSManaged var entityId: String
    @NSManaged var createdAt: NSDate
    @NSManaged var modifiedAt: NSDate
    @NSManaged var dream: Dream

}
