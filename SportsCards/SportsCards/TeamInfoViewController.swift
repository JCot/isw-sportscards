//
//  TeamInfoViewController.swift
//  SportsCards
//
//  Created by Ashlyn Lee on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import UIKit
import CoreData

class TeamInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var team: Team?
    var stats: [TeamStats]?
    private var keyboardMovedFrame: Bool = false
    private var keyboardOffset: CGFloat = 80.0

    // MARK: Outlets
    @IBOutlet weak var tableViewStats: UITableView!
    @IBOutlet weak var textFieldTeamName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboardOnOutsideTap"))
        tap.delegate = self
        view.addGestureRecognizer(tap)

        self.tableViewStats.dataSource = self
        self.tableViewStats.delegate = self
        
        self.getTeam()
        self.textFieldTeamName.text = self.team?.name
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard Manipulation
    func keyboardWillShow() {
        if !self.textFieldTeamName.editing {
            let rect = self.view.frame
            UIView.setAnimationDuration(0.3)
            //rect.origin.y = rect.origin.y - self.keyboardOffset
            self.view.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) - self.keyboardOffset, CGRectGetWidth(rect), CGRectGetHeight(rect) + self.keyboardOffset)
            self.keyboardMovedFrame = true
        }
    }
    
    func keyboardWillHide() {
        if self.keyboardMovedFrame {
            let rect = self.view.frame
            UIView.setAnimationDuration(0.3)
            //rect.origin.y = rect.origin.y - self.keyboardOffset
            self.view.frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(UIScreen.mainScreen().bounds))
            self.keyboardMovedFrame = false
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        self.keyboardOffset = touch.locationInView(self.view).y - 80.0
        return true
    }
    
    func dismissKeyboardOnOutsideTap() {
        self.textFieldTeamName.resignFirstResponder()
        self.textFieldTeamName.endEditing(true)
        self.tableViewStats.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Data Fetching
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
        self.stats = self.team?.stats.sortedArrayUsingDescriptors([NSSortDescriptor(key: "name", ascending: true)]) as? [TeamStats]
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
        self.updateStatsFromTable()
        self.context?.save(nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addStatTapped(sender: AnyObject) {
        //let statCount = self.stats?.count ?? 1
        //self.tableViewStats.insertRowsAtIndexPaths([NSIndexPath(forRow: statCount - 1, inSection: 0)], withRowAnimation: .Automatic)
        //self.tableViewStats.selectRowAtIndexPath(NSIndexPath(forRow: statCount - 1, inSection: 0), animated: true, scrollPosition: .Bottom)
        
        self.updateStatsFromTable()
        if let context = self.context {
            let newStat = TeamStats.createInContext(context, name: "", team: self.team)
            self.stats?.append(newStat)
            self.tableViewStats.reloadData()
            let currentCell = self.tableViewStats.cellForRowAtIndexPath(NSIndexPath(forRow: self.stats?.count ?? 0, inSection: 0)) as? EditableTableViewCell
            currentCell?.textField.becomeFirstResponder()
        }
    }
    
    // super janky way of making changes, but it works for the time being
    private func updateStatsFromTable() {
        if let stats = self.stats {
            for i in 0..<stats.count {
                let newName = (self.tableViewStats.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? EditableTableViewCell)?.textField.text
                if newName != nil && newName != stats[i].name {
                    stats[i].name = newName!
                }
            }
        }
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let statName = stats?[indexPath.row].name
        println(statName)
    }

    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.stats?.count ?? 0
        return rows
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
}
