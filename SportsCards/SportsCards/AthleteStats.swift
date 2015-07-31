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

    @NSManaged var value: Double
    @NSManaged var athlete: Athlete
    @NSManaged var teamStat: TeamStats

    class func createInContext(context: NSManagedObjectContext, value: Double, teamStat: TeamStats, athlete: Athlete) -> AthleteStats {
        let newAthleteStat = NSEntityDescription.insertNewObjectForEntityForName("AthleteStats", inManagedObjectContext: context) as! AthleteStats
        newAthleteStat.value = value
        newAthleteStat.teamStat = teamStat
        newAthleteStat.athlete = athlete
        return newAthleteStat
    }
    
    class func getFromContext(context: NSManagedObjectContext) -> [AthleteStats]? {
        let fetchRequest = NSFetchRequest(entityName: "AthleteStats")
        let sort = NSSortDescriptor(key: "teamStat.name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        return context.executeFetchRequest(fetchRequest, error: nil) as? [AthleteStats]
    }
    
    class func getFromContextByStatName(context: NSManagedObjectContext, statName: String) -> [AthleteStats]? {
        let fetchRequest = NSFetchRequest(entityName: "AthleteStats")
        let sort = NSSortDescriptor(key: "teamStat.name", ascending: true)
        let filter = NSPredicate(format: "teamStat.name = %s", statName)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = filter
        return context.executeFetchRequest(fetchRequest, error: nil) as? [AthleteStats]
    }
}
