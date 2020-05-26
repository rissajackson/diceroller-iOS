//
//  Monster.swift
//  diceroller_finalproject
//
//  Created by Tristan Hsieh on 11/23/19.
//  Copyright © 2019 Razerware. All rights reserved.
//

import UIKit

class Monster: NSObject {
    var name: String;
    var attackRange: Array<Int>;
    var hp: Int32;
    var totalHp: Int32;
    var image: UIImage;
    
    init(name: String, attackRange: Array<Int>, hp: Int32, totalHp: Int32, image: UIImage){
        self.name = name;
        self.attackRange = attackRange;
        self.hp = hp;
        self.totalHp = totalHp;
        self.image = image;
    }
}
