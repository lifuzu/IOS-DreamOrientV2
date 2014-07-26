//
//  Dream.swift
//  DreamOrient
//
//  Created by Richard Lee on 7/25/14.
//  Copyright (c) 2014 Weimed LLC (weimed.com). All rights reserved.
//

import Foundation
import CoreData

@objc(Dream)
class Dream: NSManagedObject {

    @NSManaged var subject: String
    @NSManaged var credits: NSNumber

}
