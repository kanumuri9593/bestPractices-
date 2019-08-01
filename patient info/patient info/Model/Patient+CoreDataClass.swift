//
//  Patient+CoreDataClass.swift
//  patient info
//
//  Created by Yeswanth Kanumuri on 7/31/19.
//  Copyright © 2019 BeTorchBearer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Patient)
public class Patient: NSManagedObject {

    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        return df
    }()
    
    func update(with jsonDictionary: [String: Any]) throws {
        guard let id = jsonDictionary["id"] as? Int,
            let fname = jsonDictionary["fname"] as? String,
            let lname = jsonDictionary["lname"] as? String,
            let dob = jsonDictionary["dob"] as? String,
            let location = jsonDictionary["location"] as? String
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }
        
        
        self.id = Int32(truncating: NSNumber(value: id))
        self.fname = fname
        self.lname = lname
        self.dob = Patient.dateFormatter.date(from: dob) as NSDate? ?? Date(timeIntervalSince1970: 0) as NSDate
        self.location = location
    }

    
}
