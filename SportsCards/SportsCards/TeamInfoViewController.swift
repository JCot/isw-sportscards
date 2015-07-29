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

        if let context = self.context {
            self.team = Team.getFromContext(context)?[0]
            self.stats = team?.stats.allObjects as? [TeamStats]
        }
        
        self.tableViewStats.dataSource = self
        self.tableViewStats.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.team?.stats.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamStats") as! EditableTableViewCell
        cell.textField.text = stats?[indexPath.row].name
        return cell
    }
}
