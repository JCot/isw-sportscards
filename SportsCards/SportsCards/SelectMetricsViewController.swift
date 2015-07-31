//
//  SelectMetricsViewController.swift
//  SportsCards
//
//  Created by Alex Greene on 7/30/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import UIKit

class SelectMetricsViewController : UITableViewController {
    
    var stats: [AthleteStats] = []
    var athlete: Athlete!
    
    let MAX_SELECTED = 4
    var numSelected = 0
    
    var statsArr = [String]()
    var valuesArr = [String]()
    
    var statsToDisplay = [String]()
    var valuesToDisplay = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        stats = (self.athlete.stats?.sortedArrayUsingDescriptors([NSSortDescriptor(key: "teamStat.name", ascending: true)]) as? [AthleteStats])!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark
            {
                numSelected--
                cell.accessoryType = .None
            }
            else
            {
                if(numSelected < MAX_SELECTED) {
                    numSelected++
                    cell.accessoryType = .Checkmark
                }
            }
        }
    }
    
    func getChecked()
    {
        for i in 0...tableView.numberOfSections()-1
        {
            for j in 0...tableView.numberOfRowsInSection(i)-1
            {
                if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i)) {
                    if cell.accessoryType == .Checkmark {
                        statsArr.append(cell.textLabel!.text!)
                        valuesArr.append(cell.detailTextLabel!.text!)
                    }
                }
                
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.stats.count ?? 0
        return rows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AthleteStatCell") as! UITableViewCell
        
        var row = indexPath.row
        var statInRow: AthleteStats = stats[row] as AthleteStats
        
        cell.textLabel?.text = statInRow.teamStat.name
        cell.detailTextLabel!.text = String(stringInterpolationSegment: statInRow.value)

        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
            
            getChecked()
            statsToDisplay = statsArr
            valuesToDisplay = valuesArr
        
    }
    
    
}