//
//  TeamInfoViewController.swift
//  SportsCards
//
//  Created by Ashlyn Lee on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import UIKit
import CoreData

class TeamInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var team: Team?
    var stats: [TeamStats]?

    // MARK: Outlets
    @IBOutlet weak var tableViewStats: UITableView!
    @IBOutlet weak var textFieldTeamName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboardOnOutsideTap"))
        view.addGestureRecognizer(tap)

        self.tableViewStats.dataSource = self
        self.tableViewStats.delegate = self
        
        self.getTeam()
        self.textFieldTeamName.text = self.team?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboardOnOutsideTap() {
        self.tableViewStats.endEditing(true)
    }
    
    private func getStats() {
        if let context = context {
            let teams = Team.getFromContext(context)
            //self.team = teams?[0]
            self.stats = TeamStats.getFromContext(context)
        }
    }
    
    private func getTeam() {
        if let context = context {
            let teams = Team.getFromContext(context)
            if teams?.count > 0 {
                self.team = teams?[0]
            } else {
                self.team = Team.createInContext(context, name: self.textFieldTeamName.text, sport: "baseball")
            }
        }
        //self.seed()
        self.stats = self.team?.stats.allObjects as? [TeamStats]
    }
    
    private func seed() {
        if let context = self.context {
            var items = [
                ("RBI", self.team),
                ("Bases Stolen", self.team),
                ("Hits", self.team),
                ("At-Bats", self.team)
            ]
            var stats = [TeamStats]()
            for (statName, team) in items {
                let teamStat = TeamStats.createInContext(context, name: statName, team: team!)
                stats.append(teamStat)
            }
            team?.stats = NSSet(array: stats)
            self.context?.save(nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelTapped(sender: AnyObject) {
        self.context?.rollback()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        self.team?.name = self.textFieldTeamName.text
        if let stats = self.stats {
            self.team?.stats = NSSet(array: stats)
        }
        self.context?.save(nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addStatTapped(sender: AnyObject) {
        //self.tableViewStats.insertRowsAtIndexPaths([NSIndexPath(index: self.stats?.count ?? 0)], withRowAnimation: .Automatic)
        //self.tableViewStats.selectRowAtIndexPath(NSIndexPath(index: self.stats?.count ?? 0), animated: true, scrollPosition: .Bottom)
        let title = "Track New Stat"
        let prompt = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        
        var statTextField: UITextField?
        prompt.addTextFieldWithConfigurationHandler {
            (textField) -> Void in
            statTextField = textField
            textField.placeholder = "Stat Name"
        }
        
        prompt.addAction(UIAlertAction(title: "Add", style: .Default, handler: {
            (action) -> Void in
            if let textField = statTextField,
                let team = self.team,
                let context = self.context
            {
                let stat = TeamStats.createInContext(context, name: textField.text, team: team)
                self.stats?.append(stat)
                self.tableViewStats.reloadData()
            }
        }))
        
        prompt.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(prompt, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let statName = stats?[indexPath.row].name
        println(statName)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.stats?.count ?? 0
        return rows
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatCell") as! EditableTableViewCell
        cell.textField.text = stats?[indexPath.row].name
        cell.textField.borderStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
        
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let statToDelete = self.stats?[indexPath.row] {
                context?.deleteObject(statToDelete)
                self.getStats()
                self.tableViewStats.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        /*let index = indexPath.row
        let statCount = self.stats?.count
        if index < statCount {
            if let editedStat = self.stats?[index],
                let cell = tableViewStats.cellForRowAtIndexPath(indexPath) as? EditableTableViewCell
            {
                editedStat.name = cell.textField.text
            }
        }*/
    }
}
