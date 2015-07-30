//
//  Positions.swift
//  SportsCards
//
//  Created by Justin Cotner on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import CoreData

class Positions: NSManagedObject {

    @NSManaged var position: String
    @NSManaged var athlete: NSSet
    
    class func createInContext(context: NSManagedObjectContext, position: String) -> Positions {
        let newPosition = NSEntityDescription.insertNewObjectForEntityForName("Positions", inManagedObjectContext: context) as! Positions
        newPosition.position = position
        
        return newPosition
    }
    
    class func getFromContext(context: NSManagedObjectContext) -> [Positions]? {
        let fetchRequest = NSFetchRequest(entityName: "Positions")
        let sort = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        return context.executeFetchRequest(fetchRequest, error: nil) as? [Positions]
    }
    
    class func getFromContextByPosition(context: NSManagedObjectContext, position: String) -> [Positions]? {
        let fetchRequest = NSFetchRequest(entityName: "Positions")
        let sort = NSSortDescriptor(key: "position", ascending: true)
        let filter = NSPredicate(format: "position == %s", position)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = filter
        return context.executeFetchRequest(fetchRequest, error: nil) as? [Positions]
    }
    
    class func getFromContextByAthlete(context: NSManagedObjectContext, athlete: Athlete?) -> [Positions]? {
        if let athlete = athlete {
            let fetchRequest = NSFetchRequest(entityName: "Positions")
            let sort = NSSortDescriptor(key: "position", ascending: true)
            let teamFilter = NSPredicate(format: "athlete contains[c] %@", athlete)
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.predicate = teamFilter
            return context.executeFetchRequest(fetchRequest, error: nil) as? [Positions]
        } else {
            return self.getFromContext(context)
        }
    }
}
