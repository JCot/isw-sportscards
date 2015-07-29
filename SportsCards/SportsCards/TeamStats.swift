//
//  TeamStats.swift
//  SportsCards
//
//  Created by Justin Cotner on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import CoreData

class TeamStats: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var team: NSSet

    class func createInContext(context: NSManagedObjectContext, name: String) -> TeamStats {
        let newStat = NSEntityDescription.insertNewObjectForEntityForName("TeamStats", inManagedObjectContext: context) as! TeamStats
        newStat.name = name
        return newStat
    }
    
    class func getFromContext(context: NSManagedObjectContext) -> [TeamStats]? {
        let fetchRequest = NSFetchRequest(entityName: "TeamStats")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        return context.executeFetchRequest(fetchRequest, error: nil) as? [TeamStats]
    }
}
