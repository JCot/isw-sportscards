//
//  RoundedRectButton.swift
//  SportsCards
//
//  Created by Ashlyn Lee on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

import UIKit

@IBDesignable class RoundedRectButton: UIButton {
    @IBInspectable var borderRadius: CGFloat = 10 {
        didSet {
            self.layer.cornerRadius = self.borderRadius
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.grayColor() {
        didSet {
            self.layer.borderColor = self.borderColor.CGColor
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            self.layer.borderWidth = self.borderWidth
            self.setNeedsLayout()
        }
    }
    
    /*@IBInspectable var contentPadding: CGFloat = 1 {
        didSet {
            self.padContent()
            self.setNeedsLayout()
        }
    }
    
    private func padContent() {
        self.bounds = CGRectInset(self.frame, self.contentPadding, self.contentPadding)
        self.clipsToBounds = true
    }*/
}