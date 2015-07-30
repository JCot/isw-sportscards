//
//  Stats.swift
//  SportsCards
//
//  Created by Justin Cotner on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import CoreData

class AthleteStats: NSManagedObject {

    @NSManaged var value: NSNumber
    @NSManaged var athlete: Athlete
    @NSManaged var teamStat: TeamStats

    class func createInContext(context: NSManagedObjectContext, value: Double, athlete: Athlete, teamStat: TeamStats) -> AthleteStats {
        let newAthleteStat = NSEntityDescription.insertNewObjectForEntityForName("AthleteStats", inManagedObjectContext: context) as! AthleteStats
        newAthleteStat.value = value
        newAthleteStat.athlete = athlete
        newAthleteStat.teamStat = teamStat
        return newAthleteStat
    }
    
    class func getFromContext(context: NSManagedObjectContext) -> [AthleteStats]? {
        let fetchRequest = NSFetchRequest(entityName: "AthleteStats")
        let sort = NSSortDescriptor(key: "teamStat.name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        return context.executeFetchRequest(fetchRequest, error: nil) as? [AthleteStats]
    }
    
    class func getFromContextByAthlete(context: NSManagedObjectContext, athlete: Athlete?) -> [AthleteStats]? {
        if let athlete = athlete {
            let fetchRequest = NSFetchRequest(entityName: "AthleteStats")
            let sort = NSSortDescriptor(key: "teamStat.name", ascending: true)
            let teamFilter = NSPredicate(format: "athlete == %@", athlete)
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.predicate = teamFilter
            return context.executeFetchRequest(fetchRequest, error: nil) as? [AthleteStats]
        } else {
            return self.getFromContext(context)
        }
    }
}
