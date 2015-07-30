//
//  SelectMetricsViewController.swift
//  SportsCards
//
//  Created by Alex Greene on 7/30/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SelectMetricsViewController : UITableViewController {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var athleteStats: [AthleteStats]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //self.getAthleteStats()
    }
    /*
    private func getAthleteStats() {
        if let context = context {
            self.athleteStats = AthleteStats.getFromContext(context)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let statName = athleteStats?[indexPath.row].athlete.name ...
        let statValue = athleteStats?[indexPath.row]. ...
        //add selected row to ->selected array
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark
            {
                cell.accessoryType = .None
            }
            else
            {
                cell.accessoryType = .Checkmark
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.athleteStats?.count ?? 0
        return rows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AthleteStatCell") as! UITableViewCell
        
        cell.textLabel?.text = athleteStats?[indexPath.row].athlete.name // or something like this
        cell.detailTextLabel!.text = athleteStats?[indexPath.row].value.stringValue
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
*/
}