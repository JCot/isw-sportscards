//
//  Positions.swift
//  SportsCards
//
//  Created by Justin Cotner on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import CoreData

class Positions: NSManagedObject {

    @NSManaged var position: String
    @NSManaged var athlete: NSSet

}
