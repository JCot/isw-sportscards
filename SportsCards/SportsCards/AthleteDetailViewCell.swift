//
//  AthleteDetailViewCell.swift
//  SportsCards
//
//  Created by Justin Cotner on 7/30/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import UIKit

class AthleteDetailViewCell: UITableViewCell {

    @IBOutlet weak var statNameLabel: UILabel!
    @IBOutlet weak var statValueField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
