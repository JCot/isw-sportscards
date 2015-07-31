//
//  Team.swift
//  SportsCards
//
//  Created by Justin Cotner on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import UIKit
import CoreData

enum Sport: String {
    case Baseball = "baseball"
    case Basketball = "basketball"
    case Football = "football"
    case Tennis = "tennis"
    case Swimming = "swimming"
    case Running = "running"
    case Soccer = "soccer"
    case Volleyball = "volleyball"
    case Hockey = "hockey"
    
    static let allSports = [Baseball, Basketball, Football, Tennis, Swimming, Running, Soccer, Volleyball, Hockey]
    
    func getImage() -> UIImage? {
        let iconString = self.rawValue + "_icon"
        return UIImage(named: iconString)
    }
}

class Team: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var sport: String
    @NSManaged var athletes: NSSet?
    @NSManaged var stats: NSSet
    var sportValue: Sport? {
        didSet {
            self.sport = self.sportValue?.rawValue ?? "baseball"
        }
    }

    class func createInContext(context: NSManagedObjectContext, name: String, sport: Sport?) -> Team {
        let newTeam = NSEntityDescription.insertNewObjectForEntityForName("Team", inManagedObjectContext: context) as! Team
        newTeam.name = name
        newTeam.sportValue = sport
        return newTeam
    }
    
    class func getFromContext(context: NSManagedObjectContext) -> [Team]? {
        let fetchRequest = NSFetchRequest(entityName: "Team")
        let teams = context.executeFetchRequest(fetchRequest, error: nil) as? [Team]
        if let teams = teams {
            for team in teams {
                team.sportValue = Sport(rawValue: team.sport)
            }
        }
        return teams
    }
}
