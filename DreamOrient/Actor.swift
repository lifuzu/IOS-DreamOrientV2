//
//  Actor.swift
//  DreamOrient
//
//  Created by Richard Lee on 7/28/14.
//  Copyright (c) 2014 Weimed LLC (weimed.com). All rights reserved.
//

import Foundation
import CoreData

@objc(Actor)
class Actor: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var credits: NSNumber
    @NSManaged var entityId: String
    @NSManaged var dreams: NSMutableSet

}
