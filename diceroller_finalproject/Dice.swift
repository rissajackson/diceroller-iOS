//
//  Dice.swift
//  diceroller_finalproject
//
//  Created by Rissabubbles on 11/17/19.
//  Copyright © 2019 Razerware. All rights reserved.
//

import Foundation
import UIKit

protocol DiceProtocol {
    func responseError()
    func responseDiceHandler(value: Int)
}

class Dice {
    private let session = URLSession.shared
    private let getURL: String = "http://roll.diceapi.com/json/"
    private var diceTypes: String = ""
    
    var delegate:DiceProtocol? = nil
    
    func getTask(dice: String) {
        self.diceTypes = dice
        let newUrl = URL(string: self.getURL + diceTypes)
        var success = false
        let task = session.dataTask(with: newUrl!) { data, response, error in
            do {
                if let newData = data {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                    guard let jsonARRAY = jsonResponse as? [String: Any] else {
                        self.delegate?.responseError()
                       return
                    }
                    if let root = jsonARRAY["dice"] as? NSArray {
                        let die = root[0] as? NSDictionary
                        let result = die?.value(forKey: "value") as! Int
                        print(result);
                        self.delegate?.responseDiceHandler(value: result)
                            success = true
        
                    }
                    else {
                        print(jsonARRAY)
                    }
                    return
                } else {
                    // The network is off or failed
                    var result = 0;
                    print(dice);
                    switch(dice){
                        case "d4":
                            result = Int(arc4random_uniform(4)) + 1;
                            break;
                        case "d6":
                            result = Int(arc4random_uniform(6)) + 1;
                            break;
                        case "d8":
                            result = Int(arc4random_uniform(8)) + 1;
                            break;
                        case "d10":
                            result = Int(arc4random_uniform(10)) + 1;
                            break;
                        case "d12":
                            result = Int(arc4random_uniform(12)) + 1;
                            break;
                        case "d20":
                            result = Int(arc4random_uniform(20)) + 1;
                            break;
                        default:
                            result = 1;
                            break;
                    }
                    self.delegate?.responseDiceHandler(value: result);
                        success = true
                    return
                }

            } catch let parsingError {
                print("error", parsingError)
            }

        }
        task.resume()
    }
}
