//
//  AddAthleteViewController.swift
//  SportsCards
//
//  Created by Alex Greene on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import UIKit

class AddAthleteViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var newPosition: UITextField!

    @IBOutlet weak var positions: UITableView!

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var athleteName = ""
    var athleteNumber = ""
    var athleteEmail = ""
    var athletePositions = [String]()
    
    var positionList = [String]()
    
    //var athletePositions = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.name.delegate = self
        self.number.delegate = self
        self.email.delegate = self
        self.newPosition.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboardOnOutsideTap:"))
        view.addGestureRecognizer(tap)
        
        self.positions.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TextInputCell")
        
        positions.tableFooterView = UIView(frame: CGRectZero)
        
        positions.delegate = self
        positions.dataSource = self
        
        saveButton.enabled = false
        
        //positionList = ["Add Position +"]
    }
    
    @IBAction func submit(sender: AnyObject) {
        var pos = newPosition.text;
        if(pos != "") {
            positionList.append(pos)
        }
        newPosition.text = ""
        self.positions.reloadData()
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return positionList.count
    }
    
    func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell = positions.dequeueReusableCellWithIdentifier("TextInputCell") as! UITableViewCell
        
        //cell.configure(text: "", placeholder: "Add Position +")
        cell.textLabel?.text = positionList[indexPath.row]
        
        return cell
    }
    
    func dismissKeyboardOnOutsideTap(recognizer: UITapGestureRecognizer) {
        name.resignFirstResponder()
        number.resignFirstResponder()
        email.resignFirstResponder()
        newPosition.resignFirstResponder()
        
        if (name.text != "") && (number.text != "") && (email.text != "") {
            saveButton.enabled = true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        if (name.text != "") && (number.text != "") && (email.text != "") {
          saveButton.enabled = true
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "saveSegue" {
            
            athleteName = name.text
            athleteNumber = number.text
            athleteEmail = email.text
            athletePositions = positionList
                        
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
}
