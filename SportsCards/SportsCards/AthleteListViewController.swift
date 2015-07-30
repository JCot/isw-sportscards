//
//  AthleteListViewController.swift
//  SportsCards
//
//  Created by Alex Greene on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AthleteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var athletes: [Athlete]? = []
    @IBOutlet weak var athleteListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.athleteListView.delegate = self
        self.athleteListView.dataSource = self
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.athletes?.count ?? 0
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AthleteCell") as! UITableViewCell
        
        cell.textLabel?.text = self.athletes?[indexPath.row].name
        cell.detailTextLabel?.text = self.athletes?[indexPath.row].number
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        var athleteDetailVC = segue.sourceViewController as! AddAthleteViewController
    }
    
    @IBAction func save(segue:UIStoryboardSegue) {
        
        var addAthleteVC = segue.sourceViewController as! AddAthleteViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //TODO Check if athlete already exists
        
        let athlete =  Athlete.createInContext(self.context!, name: addAthleteVC.athleteName, number: addAthleteVC.athleteNumber, email: addAthleteVC.athleteEmail)
        
        var positions = addAthleteVC.positionList
        var positionSet: [Positions] = []
        for var i = 0; i < positions.count; i++ {
            var result = Positions.getFromContextByPosition(self.context!, position: positions[i])
            
            if(result == nil || result?.count == 0){
                var newPosition = Positions.createInContext(self.context!, position: positions[i])
                newPosition.athlete = NSSet(object: athlete)
                positionSet.append(newPosition)
            }
            
            else{
                var position = result?[0]
                var positionAthletes = position?.athlete.allObjects
                positionAthletes?.append(athlete)
                position?.athlete = NSSet(array: positionAthletes!)
                positionSet.append(position!)
            }
        }
        
        var stats: [TeamStats]? = TeamStats.getFromContext(context!)
        var athleteStats: [AthleteStats] = []
        for var i = 0; i < stats?.count ?? 0; i++ {
            var stat = stats?[i]
            if(stat != nil) {
                var newAthleteStat = AthleteStats.createInContext(context!, value: 0.0, teamStat: stat!, athlete: athlete)
                athleteStats.append(newAthleteStat)
            }
        }
        
        athlete.stats = NSSet(array: athleteStats)
        
        self.athletes?.append(athlete)
        
        let indexPath = NSIndexPath(forRow: (athletes?.count ?? 1) - 1, inSection: 0)
        self.athleteListView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    @IBAction func saveAthleteDetails(segue:UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAthleteDetails" {
            var navController = segue.destinationViewController as! UINavigationController
            var showDetailVC = navController.topViewController as! AthleteDetailsViewController
            let indexPath = self.athleteListView.indexPathForSelectedRow()
            let cell = self.athleteListView.cellForRowAtIndexPath(indexPath!)
            var name = cell?.textLabel?.text
            var result = Athlete.getFromContext(context!)
            showDetailVC.athlete = result?[0]
        }
    }

    
}
