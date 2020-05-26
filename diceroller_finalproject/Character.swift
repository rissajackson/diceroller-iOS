//
//  Character.swift
//  diceroller_finalproject
//
//  Created by Tristan Hsieh on 11/15/19.
//  Copyright © 2019 Razerware. All rights reserved.
//

import UIKit

class Character: NSObject {
    var name: String;
    var charClass: String;
    var hp: Int;
    var totalHp: Int;
    var image: UIImage;
    
    init(name: String, charClass: String, hp: Int, totalHp: Int, image: UIImage){
        self.name = name;
        self.charClass = charClass;
        self.hp = hp;
        self.totalHp = totalHp;
        self.image = image;
    }
}
