//
//  AthleteDetailsViewController.swift
//  SportsCards
//
//  Created by Justin Cotner on 7/30/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import UIKit

class AthleteDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var athlete: Athlete?
    var stats: [AthleteStats]?
    @IBOutlet var athleteNameField: UITextField!
    @IBOutlet var athleteNumberField: UITextField!
    @IBOutlet var athleteEmailField: UITextField!
    @IBOutlet var athletePositionsField: UITextField!
    @IBOutlet var athleteDetailsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        
        self.athleteNameField.delegate = self
        self.athleteNumberField.delegate = self
        self.athleteEmailField.delegate = self
        self.athletePositionsField.delegate = self
        
        self.athleteDetailsTable.dataSource = self
        self.athleteDetailsTable.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboardOnOutsideTap:"))
        view.addGestureRecognizer(tap)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.setupView()
    }
    
    private func setupView() {
        athleteNameField.text = athlete?.name
        athleteNumberField.text = athlete?.number
        athleteEmailField.text = athlete?.email
        self.getPositionString()
        
        self.stats = self.athlete?.stats?.sortedArrayUsingDescriptors([NSSortDescriptor(key: "teamStat.name", ascending: true)]) as? [AthleteStats]
        self.athleteDetailsTable.reloadData()
    }
    
    private func getPositionString() {
        var positions: [Positions]? = athlete?.position.sortedArrayUsingDescriptors([NSSortDescriptor(key: "position", ascending: true)]) as? [Positions]
        var positionsString = ""
        for var i = 0; i < positions?.count ?? 0; i++ {
            positionsString += positions?[i].position ?? ""
            
            if(i < (positions?.count ?? 0) - 1){
                positionsString += ", "
            }
        }
        
        athletePositionsField.text = positionsString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // super janky way of making changes, but it works for the time being
    private func updateStatsFromTable() {
        if let stats = self.stats {
            for i in 0..<stats.count {
                let cell = self.athleteDetailsTable.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? AthleteDetailViewCell
                let valueString = cell?.statValueField.text ?? ""
                let newValue = NSString(string: valueString).doubleValue
                if newValue != stats[i].value {
                    stats[i].value = newValue
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.stats?.count ?? 0
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatValueCell") as! AthleteDetailViewCell
        var row = indexPath.row
        var allStats = athlete?.stats?.allObjects
        var statInRow: AthleteStats = allStats?[row] as! AthleteStats
        
        cell.statName.text = statInRow.teamStat.name
        cell.statValueField.text = String(stringInterpolationSegment: statInRow.value)
        cell.statValueField.textAlignment = .Right
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func dismissKeyboardOnOutsideTap(recognizer: UITapGestureRecognizer) {
        athleteNameField.resignFirstResponder()
        athleteNumberField.resignFirstResponder()
        athleteEmailField.resignFirstResponder()
        athletePositionsField.resignFirstResponder()
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.updateStatsFromTable()
    }
}
