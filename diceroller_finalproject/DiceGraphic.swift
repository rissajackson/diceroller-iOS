//
//  DiceGraphic.swift
//  diceroller_finalproject
//
//  Created by Rissabubbles on 11/18/19.
//  Copyright © 2019 Razerware. All rights reserved.
//

import UIKit

@IBDesignable

class DiceGraphic: UIView {
    private struct Constants {
        static let plusLineWidth: CGFloat = 3.0
        
    }
    
    override func draw(_ rect: CGRect) {
        let rect = CGRect(x:0, y: 0, width: 100, height: 100)
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: 20)
        let circle = UIBezierPath(ovalIn: rect)
        UIColor.blue.setFill()
        roundedRect.fill()
  
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
