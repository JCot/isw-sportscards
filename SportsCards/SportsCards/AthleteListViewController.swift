//
//  AthleteListViewController.swift
//  SportsCards
//
//  Created by Alex Greene on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import UIKit

class AthleteListViewController: UIViewController {
    
    var newAthlete = ""
    var athletes = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        var athleteDetailVC = segue.sourceViewController as! AddAthleteViewController
    }
    
    @IBAction func save(segue:UIStoryboardSegue) {
        
        var addAthleteVC = segue.sourceViewController as! AddAthleteViewController
        newAthlete = addAthleteVC.athleteName
        athletes.append(newAthlete)
    }

    
}
