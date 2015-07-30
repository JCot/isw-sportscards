//
//  Team.swift
//  SportsCards
//
//  Created by Justin Cotner on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import CoreData

class Team: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var sport: String
    @NSManaged var athletes: NSSet?
    @NSManaged var stats: NSSet

    class func createInContext(context: NSManagedObjectContext, name: String, sport: String) -> Team {
        let newTeam = NSEntityDescription.insertNewObjectForEntityForName("Team", inManagedObjectContext: context) as! Team
        newTeam.name = name
        newTeam.sport = sport
        return newTeam
    }
    
    class func getFromContext(context: NSManagedObjectContext) -> [Team]? {
        let fetchRequest = NSFetchRequest(entityName: "Team")
        return context.executeFetchRequest(fetchRequest, error: nil) as? [Team]
    }
}
