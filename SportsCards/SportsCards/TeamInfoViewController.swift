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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewStats.dataSource = self
        self.tableViewStats.delegate = self
        if let context = self.context {
            var items = ["RBI", "Bases Stolen", "Hits", "At-Bats"]
            for statName in items {
                TeamStats.createInContext(context, name: statName)
            }
        }
        
        self.getStats()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getStats() {
        if let context = context {
            let teams = Team.getFromContext(context)
            //self.team = teams?[0]
            self.stats = TeamStats.getFromContext(context)
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let statName = stats?[indexPath.row].name
        println(statName)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.team?.stats.count ?? 0
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EditableTableViewCell") as! EditableTableViewCell
        cell.textLabel?.text = stats?[indexPath.row].name
        cell.textField.text = stats?[indexPath.row].name
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
}
