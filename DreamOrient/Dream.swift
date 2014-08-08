//
//  Dream.swift
//  DreamOrient
//
//  Created by Richard Lee on 7/28/14.
//  Copyright (c) 2014 Weimed LLC (weimed.com). All rights reserved.
//

import Foundation
import CoreData

@objc(Dream)
class Dream: NSManagedObject {

    @NSManaged var no: NSNumber
    @NSManaged var name: String
    @NSManaged var credits: NSNumber
    @NSManaged var gains: NSNumber
    @NSManaged var entityId: String
    @NSManaged var rules: NSMutableSet
    @NSManaged var actor: Actor

}
