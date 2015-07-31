//
//  CardDisplayViewController.swift
//  SportsCards
//
//  Created by Alex Greene on 7/30/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MessageUI

class CardDisplayViewController : UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var displayPhoto: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var displayDescrip: UITextView!
    @IBOutlet weak var displayTeam: UILabel!
    @IBOutlet weak var displayPositions: UILabel!
    @IBOutlet weak var displayNumber: UILabel!
    
    @IBOutlet weak var displayStat1: UILabel!
    @IBOutlet weak var displayStat2: UILabel!
    @IBOutlet weak var displayStat3: UILabel!
    @IBOutlet weak var displayStat4: UILabel!
   
    var photo = UIImage()
    var name = ""
    var descrip = ""
    var team = ""
    var positions = ""
    var number = ""
    var statsArr = [String]()
    var valuesArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("displayOptions:"))
        view.addGestureRecognizer(tap)
        
        displayPhoto.contentMode = UIViewContentMode.ScaleToFill
        displayPhoto.image = photo
        displayName.text = name
        displayDescrip.text = descrip
        displayTeam.text = team
        displayPositions.text = positions
        displayNumber.text = number
        
        if(statsArr.count >= 1){
            displayStat1.text = statsArr[0] + " " + valuesArr[0]
        } else {
            displayStat1.text = ""
        }
        
        if(statsArr.count >= 2){
            displayStat2.text = statsArr[1] + " " + valuesArr[1]
        } else {
            displayStat2.text = ""
        }
        
        if(statsArr.count >= 3){
            displayStat3.text = statsArr[2] + " " + valuesArr[2]
        } else {
            displayStat3.text = ""
        }
        
        if(statsArr.count >= 4){
            displayStat4.text = statsArr[3] + " " + valuesArr[3]
        } else {
            displayStat4.text = ""
        }
        
        displayDescrip.selectable = false;
    }
    
    func displayOptions(recognizer: UITapGestureRecognizer) {
        
        var optionsMenu = UIAlertController(title: nil, message: "You have some options:", preferredStyle: .ActionSheet)
        
        let clearAction = UIAlertAction(title: "Back to the drawing board", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in self.startAgain()
        })
        
        let emailAction = UIAlertAction(title: "Send card to athlete", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in self.sendViaEmail()
            
        })
        
        let saveAction = UIAlertAction(title: "Save card to camera roll", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in self.saveToCameraRoll()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        
        optionsMenu.addAction(clearAction)
        optionsMenu.addAction(emailAction)
        optionsMenu.addAction(saveAction)
        optionsMenu.addAction(cancelAction)
        
        self.presentViewController(optionsMenu, animated: true, completion: nil)
    }
    
    func startAgain () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendViaEmail () {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setSubject("Card from your coach:")
        mailController.setMessageBody("Hey Athlete, here's a sports card I created that's got your name on it!", isHTML: false)
        mailController.setToRecipients(["alexgrn7@gmail.com"])
        
        var imageData = UIImagePNGRepresentation(image)
        mailController.addAttachmentData(imageData, mimeType: "image/png", fileName: "image")
        
        self.presentViewController(mailController, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        if result.value == MFMailComposeResultSent.value {
            let alertView = UIAlertView()
            alertView.message = "Mail Sent!"
            alertView.addButtonWithTitle("OK")
            
            alertView.show()
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func saveToCameraRoll () {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}