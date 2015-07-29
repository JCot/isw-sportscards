//
//  AddAthleteViewController.swift
//  SportsCards
//
//  Created by Alex Greene on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import UIKit

class AddAthleteViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var positions: UITableView!
    
    var athleteName = ""
    var athleteNumber = ""
    var athleteEmail = ""
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboardOnOutsideTap:"))
        view.addGestureRecognizer(tap)
        
        self.positions.registerClass(UITableViewCell.self, forCellReuseIdentifier: "positionCell")
        
        self.addPosition.delegate = self
        positions.delegate = self
        poisitions.dataSource = self
    }
    
    func dismissKeyboardOnOutsideTap(recognizer: UITapGestureRecognizer) {
        name.resignFirstResponder()
        number.resignFirstResponder()
        email.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "saveSegue" {
            
            athleteName = name.text
            athleteNumber = number.text
            athleteEmail = email.text
            
            //athletePositions = positions
            
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
}
