//
//  Athlete.swift
//  SportsCards
//
//  Created by Justin Cotner on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import CoreData

class Athlete: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var number: String
    @NSManaged var email: String
    @NSManaged var stats: NSSet?
    @NSManaged var team: Team
    @NSManaged var position: NSSet
    
    class func createInContext(context: NSManagedObjectContext, name: String, number: String, email: String) -> Athlete {
        let newAthlete = NSEntityDescription.insertNewObjectForEntityForName("Athlete", inManagedObjectContext: context) as! Athlete
        newAthlete.name = name
        newAthlete.email = email
        newAthlete.number = number
        return newAthlete
    }
    
    class func getFromContext(context: NSManagedObjectContext) -> [Athlete]? {
        let fetchRequest = NSFetchRequest(entityName: "Athlete")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        return context.executeFetchRequest(fetchRequest, error: nil) as? [Athlete]
    }

}
