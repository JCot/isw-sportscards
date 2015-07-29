//
//  Athlete.swift
//  SportsCards
//
//  Created by Justin Cotner on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import CoreData

class Athlete: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var number: Int
    @NSManaged var email: String
    @NSManaged var stats: NSSet?
    @NSManaged var team: Team
    @NSManaged var position: NSSet

}
