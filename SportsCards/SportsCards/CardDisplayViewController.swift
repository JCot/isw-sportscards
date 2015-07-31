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

class CardDisplayViewController : UIViewController {
    
    @IBOutlet weak var displayPhoto: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    
    var photo = UIImage()
    var name = ""
    var descrip = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayPhoto.contentMode = UIViewContentMode.ScaleToFill
        displayPhoto.image = photo
        displayName.text = name
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}