//
//  CreateCardViewController.swift
//  SportsCards
//
//  Created by Alex Greene on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CreateCardViewController: UITableViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var athletes: [Athlete]? = []
    var athlete: Athlete?
    var team: Team?

    @IBOutlet weak var paramsTableView: UITableView!
    
    @IBOutlet weak var athletePicker: UIPickerView!
    @IBOutlet weak var athleteSelectedLabel: UILabel!
    
    @IBOutlet weak var statisticsSelectedLabel: UILabel!
    
    @IBOutlet weak var blurb: UITextView!
    @IBOutlet weak var athleteImage: UIImageView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var generateButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()

    var athletePickerHidden = true
    var imageUploaded = false
    
    /* send through segue */
    var athletePhoto = UIImage()
    var athleteName = ""
    var positions = ""
    var athleteNumber = ""
    
    /* get from segue */
    var statsArr = [String]()
    var valuesArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        athleteSelectedLabel.text = "select"
        statisticsSelectedLabel.text = "none selected"
        
        generateButton.enabled = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        self.blurb.delegate = self
        blurb.tag = 0
        
        imagePicker.delegate = self
        
        self.athletePicker.dataSource = self
        self.athletePicker.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboardOnOutsideTap:"))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        self.getAthletes()
        self.getTeam()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func getAthletes() {
        if let context = context {
            self.athletes = Athlete.getFromContext(context)
        }
    }
    
    private func getTeam() {
        if let context = self.context {
            let teams = Team.getFromContext(context)
            if teams?.count > 0 {
                self.team = teams?[0]
            }
        }
    }
    
    private func getSelectedAthleteData() {
        var positions: [Positions]? = athlete?.position.sortedArrayUsingDescriptors([NSSortDescriptor(key: "position", ascending: true)]) as? [Positions]
        var positionsString = ""
        for var i = 0; i < positions?.count ?? 0; i++ {
            positionsString += positions?[i].position ?? ""
            
            if(i < (positions?.count ?? 0) - 1){
                positionsString += ", "
            }
        }
        self.positions = positionsString
        athleteNumber = athlete!.number
    }

    
    @IBAction func selectAthleteImage(sender: AnyObject) {
        
        var sourceMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        //imagePicker.allowsEditing = true

        
        let cameraAction = UIAlertAction(title: "Take new photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in self.takeNewPicture()
        })
        
        let libraryAction = UIAlertAction(title: "Import existing photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in self.importOldPicture()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        
        sourceMenu.addAction(cameraAction)
        sourceMenu.addAction(libraryAction)
        sourceMenu.addAction(cancelAction)
        
        self.presentViewController(sourceMenu, animated: true, completion: nil)
        
    }
    
    func takeNewPicture (){
        self.imagePicker.sourceType = .Camera
        presentViewController(self.imagePicker, animated: true, completion: nil)

    }
    
    func importOldPicture (){
        self.imagePicker.sourceType = .PhotoLibrary
        presentViewController(self.imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let selectedShot = info[UIImagePickerControllerOriginalImage] as? UIImage {
            athleteImage.contentMode = .ScaleAspectFill
            athleteImage.image = selectedShot
            
            imageUploaded = true
            
            if (imageUploaded && (athlete != nil) && (statsArr.count != 0) && (blurb != "")){
                generateButton.enabled = true
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return athletes?.count ?? 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return athletes?[row].name
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        athleteSelectedLabel.text = athletes?[row].name
        athleteSelectedLabel.textColor = UIColor.blackColor()
        
        athlete = athletes?[row]
        
        if (imageUploaded && (athlete != nil) && (statsArr.count != 0) && (blurb != "")){
            generateButton.enabled = true
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if athletePickerHidden && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            toggleAthletePicker()
            
            if(athletePickerHidden){
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
        else if indexPath.section == 1 && indexPath.row == 0 && athlete != nil {
            performSegueWithIdentifier("needToSelectMetrics", sender: CreateCardViewController.self)
        }
    }
    
    func toggleAthletePicker() {
        athletePickerHidden = !athletePickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    func dismissKeyboardOnOutsideTap(recognizer: UITapGestureRecognizer) {
        blurb.resignFirstResponder()
    }

    func textView(textView: UITextView, shouldChangeTextInRange range:NSRange, replacementText text:String ) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        var len = count(text)
        return count(blurb.text) + (len - range.length) <= 75;
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if(blurb.tag == 0) {
            blurb.text = ""
            blurb.textColor = UIColor.blackColor()
            blurb.tag = 1
        }
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        cancelButton.enabled = false
        self.view.frame.origin.y -= 150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        cancelButton.enabled = true
        self.view.frame.origin.y += 150
    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        self.getSelectedAthleteData()
        
        if segue.identifier == "needToSelectMetrics" {
            
            var navController = segue.destinationViewController as! UINavigationController
            let selectMetricsVC = navController.topViewController as! SelectMetricsViewController
            
            selectMetricsVC.athlete = athlete!
        }

        if segue.identifier == "createSegue" {
            
            let cardDisplayVC = segue.destinationViewController as! CardDisplayViewController
            
            cardDisplayVC.photo = athleteImage.image!
            cardDisplayVC.name = athleteSelectedLabel.text!
            cardDisplayVC.descrip = blurb.text
            cardDisplayVC.team = team!.name
            cardDisplayVC.positions = positions
            cardDisplayVC.number = athleteNumber
            cardDisplayVC.statsArr = statsArr
            cardDisplayVC.valuesArr = valuesArr
            cardDisplayVC.email = athlete?.email ?? ""
        }
        
    }
    
    @IBAction func returnFromStatSelection(segue:UIStoryboardSegue) {
        var selectMetricsVC = segue.sourceViewController as! SelectMetricsViewController
        statsArr = selectMetricsVC.statsArr
        valuesArr = selectMetricsVC.valuesArr
        
        if (imageUploaded && (athlete != nil) && (statsArr.count != 0) && (blurb != "")){
            generateButton.enabled = true
        }
    }
    
}