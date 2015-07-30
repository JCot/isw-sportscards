//
//  CreateCardViewController.swift
//  SportsCards
//
//  Created by Alex Greene on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import UIKit

class CreateCardViewController: UITableViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var paramsTableView: UITableView!
    
    @IBOutlet weak var athletePicker: UIPickerView!
    @IBOutlet weak var athleteSelectedLabel: UILabel!
    
    @IBOutlet weak var statisticsSelectedLabel: UILabel!
    
    @IBOutlet weak var blurb: UITextView!
    @IBOutlet weak var athleteImage: UIImageView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var generateButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    
    var pickerData = ["Jimmy", "Timmy", "Tommy", "Bill"]
    var athletePickerHidden = true
    
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
        
    }
    
    @IBAction func selectAthleteImage(sender: AnyObject) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let selectedShot = info[UIImagePickerControllerOriginalImage] as? UIImage {
            athleteImage.contentMode = .ScaleAspectFill
            athleteImage.image = selectedShot
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
        return pickerData.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        athleteSelectedLabel.text = pickerData[row]
        athleteSelectedLabel.textColor = UIColor.blackColor()
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
        else if indexPath.section == 1 && indexPath.row == 0{
            performSegueWithIdentifier("needToSelectMetrics", sender: nil)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func textView(textView: UITextView, shouldChangeTextInRange range:NSRange, replacementText text:String ) -> Bool {
        var len = count(text)
        return count(blurb.text) + (len - range.length) <= 140;
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
}