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
    @NSManaged var athletes: NSSet
    @NSManaged var stats: NSSet

}
