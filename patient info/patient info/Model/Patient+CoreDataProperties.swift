//
//  Patient+CoreDataProperties.swift
//  patient info
//
//  Created by Yeswanth Kanumuri on 7/31/19.
//  Copyright © 2019 BeTorchBearer. All rights reserved.
//
//

import Foundation
import CoreData


extension Patient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patient> {
        return NSFetchRequest<Patient>(entityName: "Patient")
    }

    @NSManaged public var dob: NSDate?
    @NSManaged public var fname: String?
    @NSManaged public var id: Int32
    @NSManaged public var lname: String?
    @NSManaged public var location: String?

}
