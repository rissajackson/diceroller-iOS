//
//  DiceViewController.swift
//  diceroller_finalproject
//
//  Created by Rissabubbles on 11/18/19.
//  Copyright © 2019 Razerware. All rights reserved.
//

import UIKit
import Foundation

let monsterArr = [
    Monster(name: "Village Girl",
                attackRange: [0,2],
                hp: 30,
                totalHp: 30,
                image: UIImage(named: "anime")!),
    Monster(name: "Demon",
                attackRange: [0,5],
                hp: 30,
                totalHp: 30,
                image: UIImage(named: "spider")!),
    Monster(name: "Demon King",
                attackRange: [4,6],
                hp: 35,
                totalHp: 35,
                image: UIImage(named: "greekgod")!),
    Monster(name: "Mini Boss",
                attackRange: [4,6],
                hp: 60,
                totalHp: 60,
                image: UIImage(named: "miniboss")!),
    Monster(name: "Final Boss",
                attackRange: [5,10],
                hp: 100,
                totalHp: 100,
                image: UIImage(named: "finalboss")!),
]

class DiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, DiceProtocol {

    @IBOutlet weak var characterProf: UIImageView!
    @IBOutlet weak var enemyProf: UIImageView!
    @IBOutlet weak var questLog: UITextView!
    @IBOutlet weak var charName: UILabel!
    @IBOutlet weak var charHP: UILabel!
    @IBOutlet weak var monsterName: UILabel!
    @IBOutlet weak var monsterHP: UILabel!
    @IBOutlet weak var diceType: UITextField!
    @IBOutlet weak var shakeGesture: UIImageView!
    @IBOutlet weak var diceAnimation: UIImageView!
    @IBOutlet var diceAnimationTap: UITapGestureRecognizer!
    
    
    @IBOutlet weak var diceLabelResults: UILabel!
    @IBOutlet weak var diceViewTap: UIImageView!
    

    
    let diceTypes = ["d4", "d6", "d8", "d10", "d12", "d20"]
    var currDice = "d4";
    var diceSession = Dice()
    
    var currMonsterIdx: Int = 0;
    var tempCharHP: Int = 0;
    var tempMonsterHP: Int32 = 0;
    var attackM: Float = 10;
    var currAttack: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diceType.delegate = self as! UITextFieldDelegate;
        if(timer!.isValid == false){
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(changeFrame), userInfo: nil, repeats: true);
        } else { // If timer is already valid, just reset timer
            timer!.invalidate();
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(changeFrame), userInfo: nil, repeats: true);
        }
        
        currMonsterIdx = 0;
        tempCharHP = focusCharacter.value(forKeyPath: "hp") as! Int;
        tempMonsterHP = monsterArr[currMonsterIdx].hp;
        
        characterProf.image = UIImage(data:focusCharacter.value(forKeyPath: "image") as! Data,scale:1.0)!
        
        questLog.text = "Roll the dice to attack!";
        updateCharacter();
        updateMonster();
        
            
        let pickerView = UIPickerView()
        pickerView.delegate = self
            
        diceType.inputView = pickerView
    
        // Do any additional setup after loading the view.
        
    
    }
    
    @objc func changeFrame(){
        frame = (frame + 1) % imageArr.count;
        diceAnimation.image = imageArr[frame]!;
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("I've been tapped")
                   if diceType.text != "" {
                       print("doing dice session .getTask")
                       diceSession.delegate = self
                       diceSession.getTask(dice: diceType.text!)
            
            }
        }
    }
    
        
    // sets number of colums in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // sets the number of rows in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return diceTypes.count
    }
    // this function sets the text of the picker view to the content of the "diceTypes" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return diceTypes[row]
        }
        
        // when user selects an option, this function will set the text of the text field to reflect the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        diceType.text = diceTypes[row]
        currDice = diceTypes[row];
    }
    
    func responseDiceHandler(value: Int) {
    
        DispatchQueue.global().async {
            //let result = String(value)
            DispatchQueue.main.async {
                //self.diceLabelResults.text = result
                self.calculateAttack(num: Float(value), den: self.currDice);
                
            }
        }

        
    }
    func responseError() {
        print("Error")
    }
    
    // MARK: Quest functionality
    
    func convertToFloat(number: String) -> Float{
        var retNum = 6.0;
        switch(number){
            case "d4":
                retNum = 4.0;
                break;
            case "d6":
                retNum = 6.0;
                break;
            case "d8":
                retNum = 8.0;
                break;
            case "d10":
                retNum = 10.0;
                break;
            case "d12":
                retNum = 12.0;
                break;
            case "d20":
                retNum = 20.0;
                break;
            default:
                retNum = 6.0;
                break;
        }
        return Float(retNum);
    }
    func calculateAttack(num: Float, den: String){
        let diceType = convertToFloat(number: den);
        print(diceType);
        
        // Different classes make the game play out a little bit differently
        switch(focusCharacter.value(forKeyPath: "charClass") as! String){
            case "Peasant":
                questLog.text! = "You rolled a \(Int(num))..."
                currAttack = Int((num/diceType) * (attackM-5));
                let timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(characterAttack), userInfo: nil, repeats: false);
                break;
            case "Knight":
                if(num == diceType){
                    questLog.text! = "Full score! You will be fully healed."
                    tempCharHP = Int(focusCharacter.value(forKeyPath: "totalHp") as! Int32); // I had to cast it as a Int32 first, because thats the only type totalHP is compliant with
                    updateCharacter();
                    let timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(waitText), userInfo: nil, repeats: false);
                } else {
                    questLog.text! = "You rolled a \(Int(num))..."
                    currAttack = Int(((num + (diceType-4))/diceType) * (attackM + 5));
                    let timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(characterAttack), userInfo: nil, repeats: false);
                }
                break;
            case "Wizard":
                if(num == diceType || num == diceType-1){
                    questLog.text! = "High score! You will be fully healed."
                    tempCharHP = Int(focusCharacter.value(forKeyPath: "totalHp") as! Int32); // I had to cast it as a Int32 first, because thats the only type totalHP is compliant with
                    updateCharacter();
                    let timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(waitText), userInfo: nil, repeats: false);
                } else {
                    questLog.text! = "You rolled a \(Int(num))..."
                    currAttack = Int(((num + (diceType-4))/diceType) * attackM);
                    let timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(characterAttack), userInfo: nil, repeats: false);
                }
                break;
            default:
                currAttack = 0;
                break;
        }
        
    }
    @objc func characterAttack(){
        let attack = Int32(currAttack);
        //diceViewTap.isEnabled = false;
        questLog.text! = "\(focusCharacter.value(forKeyPath: "name") as! String) does \(attack) damage!";
        tempMonsterHP -= attack;
        if(tempMonsterHP <= 0){
            tempMonsterHP = 0;
            updateMonster();
            let timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(deathText), userInfo: nil, repeats: false);
        } else {
            updateMonster();
            let timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(waitText), userInfo: nil, repeats: false);
        }
    }
    @objc func waitText(){
        questLog.text! = "\(monsterArr[currMonsterIdx].name) is thinking..."
        let timer = Timer.scheduledTimer(timeInterval: TimeInterval(1.6), target: self, selector: #selector(monsterAttack), userInfo: nil, repeats: false);
    }
    @objc func monsterAttack(){
        var attack = 0;
        if(focusCharacter.value(forKeyPath: "charClass") as! String == "Peasant"
            && currMonsterIdx != 0){
            attack = monsterArr[currMonsterIdx].attackRange[0] + (Int(arc4random_uniform(UInt32(monsterArr[currMonsterIdx].attackRange[1] - monsterArr[currMonsterIdx].attackRange[0] - 3))));
        } else {
            attack = monsterArr[currMonsterIdx].attackRange[0] + (Int(arc4random_uniform(UInt32(monsterArr[currMonsterIdx].attackRange[1] - monsterArr[currMonsterIdx].attackRange[0]))));
        }
        questLog.text! = "\(monsterArr[currMonsterIdx].name) does \(attack) damage!";
        tempCharHP -= attack;
        
        if(tempCharHP <= 0){
            tempCharHP = 0;
            updateCharacter();
            let timer = Timer.scheduledTimer(timeInterval: TimeInterval(1.8), target: self, selector: #selector(gameOver), userInfo: nil, repeats: false);
        } else {
            updateCharacter();
            
            let timer = Timer.scheduledTimer(timeInterval: TimeInterval(1.4), target: self, selector: #selector(resetText), userInfo: nil, repeats: false);
        }
    }
    @objc func resetText(){
        //enterButtonObj.isEnabled = true;
        questLog.text! = "It's your turn again, roll the dice!"
    }
    @objc func deathText(){
        questLog.text! = "\(monsterArr[currMonsterIdx].name) has been defeated"
        enemyProf.image! = UIImage(named: "death")!;
        
        let timer = Timer.scheduledTimer(timeInterval: TimeInterval(1.8), target: self, selector: #selector(reviveEnemy), userInfo: nil, repeats: false);
    }
    @objc func gameOver(){
        questLog.text! = "You have been defeated."
        characterProf.image! = UIImage(named: "death")!;
    }
    @objc func reviveEnemy(){
        currMonsterIdx += 1;
        if(currMonsterIdx == monsterArr.count){
            questLog.text! = "Congratulations, you win.";
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "youwin")
            self.navigationController!.pushViewController(newViewController, animated: true)
        } else {
            questLog.text! = "New enemy: \(monsterArr[currMonsterIdx].name)";
            tempMonsterHP = monsterArr[currMonsterIdx].hp;
            updateMonster();
            let timer = Timer.scheduledTimer(timeInterval: TimeInterval(1.8), target: self, selector: #selector(resetText), userInfo: nil, repeats: false);
        }
    }
    func updateCharacter(){
        charName.text! = focusCharacter.value(forKeyPath: "name") as! String
        charHP.text! =
        "\(tempCharHP)/\(focusCharacter.value(forKeyPath: "totalHp") as! Int32)";
    }
    func updateMonster(){
        monsterName.text! = monsterArr[currMonsterIdx].name;
        monsterHP.text! = "\(tempMonsterHP)/\(monsterArr[currMonsterIdx].totalHp)";
        enemyProf.image! = monsterArr[currMonsterIdx].image;
    }
    
    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
       guard recognizer.view != nil else { return }
        print("I've been tapped")
        if diceType.text != "" {
            print("doing dice session .getTask")
            diceSession.delegate = self
            diceSession.getTask(dice: diceType.text!)
        }
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
      let translation = recognizer.translation(in: self.view)
      if let view = recognizer.view {
        view.center = CGPoint(x:view.center.x + translation.x,
                                y:view.center.y + translation.y)
        if recognizer.state == UIGestureRecognizer.State.ended {
            // 1
            let velocity = recognizer.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
              
            // 2
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                       y:recognizer.view!.center.y + (velocity.y * slideFactor))
            // 4
            finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
              
            // 5
            UIView.animate(withDuration: Double(slideFactor * 2),
                             delay: 0,
                             // 6
                options: UIView.AnimationOptions.curveEaseOut,
                             animations: {recognizer.view!.center = finalPoint },
                             completion: nil)
        }
      }
      recognizer.setTranslation(CGPoint.zero, in: self.view)
    
    }
    
    func diceResponseHandler() {
        return
    }
  
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //timer!.invalidate();
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/

}
extension DiceViewController : UITextFieldDelegate {
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
      }
  }
