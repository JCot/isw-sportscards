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
    
    // MARK: Properties
    private let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var team: Team?
    var athletes: [Athlete]?
    
    // MARK: Outlets
    @IBOutlet var athleteListView: UITableView!
    
    // MARK: View Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.athleteListView.delegate = self
        self.athleteListView.dataSource = self
        
        self.getTeam()
        self.getAthletes()
}
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.getTeam()
        self.getAthletes()
        self.navigationItem.title = self.team?.name ?? "Athletes"
    }
    
    // MARK: Data Fetching
    private func getTeam() {
        if let context = context {
            let teams = Team.getFromContext(context)
            if teams?.count > 0 {
                self.team = teams?[0]
            } else {
                self.performSegueWithIdentifier("teamInfoSegue", sender: self)
            }
        }
    }
    
    func getAthletes() {
        if let context = self.context {
            self.athletes = Athlete.getFromContextByTeam(context, team: self.team)
        }
    }
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let name = athletes?[indexPath.row].name
        println(name)
    }
    
    // MARK: UITableViewDataSource
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
    
    // MARK: Segue functions
    @IBAction func cancel(segue:UIStoryboardSegue) {
        self.context?.rollback()
        //var athleteDetailVC = segue.sourceViewController as! AddAthleteViewController
    }
    
    @IBAction func save(segue:UIStoryboardSegue) {
        
        var addAthleteVC = segue.sourceViewController as! AddAthleteViewController
        
        if let context = self.context,
            let team = self.team
        {
            let athlete =  Athlete.createInContext(context, name: addAthleteVC.athleteName, number: addAthleteVC.athleteNumber, email: addAthleteVC.athleteEmail, team: team)
            
            let positions = addAthleteVC.positionList
            var positionSet: [Positions] = []
            for var i = 0; i < positions.count; i++ {
                let result = Positions.getFromContextByPosition(self.context!, position: positions[i])
                
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
            
            athlete.position = NSSet(array: positionSet)
            
            var stats: [TeamStats]? = TeamStats.getFromContext(self.context!)
            var athleteStats: [AthleteStats] = []
            for var i = 0; i < stats?.count ?? 0; i++ {
                var stat = stats?[i]
                if(stat != nil) {
                    var newAthleteStat = AthleteStats.createInContext(self.context!, value: 0.0, teamStat: stat!, athlete: athlete)
                    athleteStats.append(newAthleteStat)
                }
            }
            
            athlete.stats = NSSet(array: athleteStats)
            
            athletes?.append(athlete)
            
            let indexPath = NSIndexPath(forRow: (athletes?.count ?? 1) - 1, inSection: 0)
            athleteListView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.context?.save(nil)
        }
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
