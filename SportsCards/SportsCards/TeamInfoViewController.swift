//
//  TeamInfoViewController.swift
//  SportsCards
//
//  Created by Ashlyn Lee on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import UIKit
import CoreData

class TeamInfoViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var team: Team?
    var stats: [TeamStats]?
    private var keyboardMovedFrame: Bool = false
    private var keyboardOffset: CGFloat = 80.0

    // MARK: Outlets
    @IBOutlet var tableViewStats: UITableView!
    @IBOutlet var textFieldTeamName: UITextField!
    @IBOutlet var pickerSport: UIPickerView!
    @IBOutlet var buttonPickSport: RoundedRectButton!
    @IBOutlet var viewPickerCover: UIView!
    @IBOutlet weak var imageViewSportPicker: UIImageView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboardOnOutsideTap"))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        self.tableViewStats.dataSource = self
        
        self.pickerSport.dataSource = self
        self.pickerSport.delegate = self
        
        self.getTeam()
        self.textFieldTeamName.text = self.team?.name
        if let image = self.team?.sportValue?.getImage() {
            self.imageViewSportPicker.image = image
        } else {
            self.buttonPickSport.setTitle("⚪", forState: .Normal)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard Manipulation
    func keyboardWillShow() {
        if !self.textFieldTeamName.editing {
            let rect = self.view.frame
            UIView.setAnimationDuration(0.3)
            self.view.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) - self.keyboardOffset, CGRectGetWidth(rect), CGRectGetHeight(rect) + self.keyboardOffset)
            self.keyboardMovedFrame = true
        }
    }
    
    func keyboardWillHide() {
        if self.keyboardMovedFrame {
            let rect = self.view.frame
            UIView.setAnimationDuration(0.3)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: Data Fetching
    private func getTeam() {
        if let context = context {
            let teams = Team.getFromContext(context)
            if teams?.count > 0 {
                self.team = teams?[0]
            } else {
                self.team = Team.createInContext(context, name: self.textFieldTeamName.text, sport: nil)
            }
        }
        self.stats = self.team?.stats.sortedArrayUsingDescriptors([NSSortDescriptor(key: "name", ascending: true)]) as? [TeamStats]
    }

    // MARK: - Navigation
    @IBAction func cancelTapped(sender: AnyObject) {
        self.context?.rollback()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        self.team?.name = self.textFieldTeamName.text
        let sport = self.team?.sport
        let sportValue = self.team?.sportValue
        self.updateStatsFromTable()
        self.context?.save(nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickSportTapped(sender: AnyObject) {
        self.dismissKeyboardOnOutsideTap()
        self.pickerSport.alpha = 1
        self.viewPickerCover.alpha = 1
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.viewPickerCover.userInteractionEnabled = true
    }
    
    @IBAction func addStatTapped(sender: AnyObject) {        
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
                self.stats?.removeAtIndex(indexPath.row)
                self.tableViewStats.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }
    
    // MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return Sport.allSports[row].rawValue.capitalizedString
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sport = Sport.allSports[row]
        if let image = sport.getImage() {
            self.imageViewSportPicker.image = image
            self.buttonPickSport.setTitle("", forState: .Normal)
        } else {
            self.buttonPickSport.setTitle("Sport", forState: .Normal)
        }
        self.team?.sportValue = sport
        self.pickerSport.alpha = 0
        self.viewPickerCover.alpha = 0
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.viewPickerCover.userInteractionEnabled = false
    }
    
    // MARK: UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Sport.allSports.count
    }
}
