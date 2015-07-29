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

}
