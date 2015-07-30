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
    @NSManaged var team: Team
    @NSManaged var athleteStats: NSSet

    class func createInContext(context: NSManagedObjectContext, name: String, team: Team?) -> TeamStats {
        let newStat = NSEntityDescription.insertNewObjectForEntityForName("TeamStats", inManagedObjectContext: context) as! TeamStats
        newStat.name = name
        if let team = team {
            newStat.team = team
        }
        return newStat
    }
    
    class func getFromContext(context: NSManagedObjectContext) -> [TeamStats]? {
        let fetchRequest = NSFetchRequest(entityName: "TeamStats")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        return context.executeFetchRequest(fetchRequest, error: nil) as? [TeamStats]
    }
    
    class func getFromContextByTeam(context: NSManagedObjectContext, team: Team?) -> [TeamStats]? {
        if let team = team {
            let fetchRequest = NSFetchRequest(entityName: "TeamStats")
            let sort = NSSortDescriptor(key: "name", ascending: true)
            let filter = NSPredicate(format: "team = %@", team)
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.predicate = filter
            return context.executeFetchRequest(fetchRequest, error: nil) as? [TeamStats]
        } else {
            return self.getFromContext(context)
        }
    }
}
