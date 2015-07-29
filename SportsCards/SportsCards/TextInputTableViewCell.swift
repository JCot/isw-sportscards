//
//  TextInputTableViewCell.swift
//  SportsCards
//
//  Created by Alex Greene on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import Foundation
import UIKit

public class TextInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var positionField: UITextField!
    
    public func configure(#text: String, placeholder: String){
        positionField.text = text
        positionField.placeholder = placeholder
        
        positionField.accessibilityValue = text
        positionField.accessibilityLabel = placeholder
    }
}
