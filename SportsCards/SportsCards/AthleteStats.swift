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

}
