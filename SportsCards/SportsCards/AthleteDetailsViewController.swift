//
//  AthleteDetailsViewController.swift
//  SportsCards
//
//  Created by Justin Cotner on 7/30/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import UIKit

class AthleteDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var athlete: Athlete?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.athlete?.stats?.count ?? 0
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatValueCell") as! AthleteDetailViewCell
        var row = indexPath.row
        var allStats = athlete?.stats?.allObjects
        var statInRow: AthleteStats = allStats?[row] as! AthleteStats
        
        cell.statNameLabel.text = statInRow.teamStat.name
        cell.statValueField.text = String(stringInterpolationSegment: statInRow.value)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
