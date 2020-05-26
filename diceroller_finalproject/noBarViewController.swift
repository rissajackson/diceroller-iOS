//
//  noBarViewController.swift
//  diceroller_finalproject
//
//  Created by Tristan Hsieh on 12/6/19.
//  Copyright © 2019 Razerware. All rights reserved.
//

import UIKit

var imageArr = [
    UIImage(named: "0"),
    UIImage(named: "1"),
    UIImage(named: "2"),
    UIImage(named: "3"),
    UIImage(named: "4"),
    UIImage(named: "5"),
    UIImage(named: "6"),
    UIImage(named: "7"),
    UIImage(named: "8"),
    UIImage(named: "9"),
    UIImage(named: "10"),
    UIImage(named: "11"),
    UIImage(named: "12"),
    UIImage(named: "13"),
    UIImage(named: "14"),
    UIImage(named: "15"),
    UIImage(named: "16"),
    UIImage(named: "17"),
    UIImage(named: "18"),
    UIImage(named: "19"),
]
var frame = 0;
var isTitleScreen = true;
var timer: Timer?;

class noBarViewController: UIViewController {

    @IBOutlet weak var spinAni: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isHidden = true;
        // Do any additional setup after loading the view.
        if(isTitleScreen){ // only plays the animation if you are at the titlescreen
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(changeFrame), userInfo: nil, repeats: true);
        }
        
    }
    
    @objc func changeFrame(){
        frame = (frame + 1) % imageArr.count;
        spinAni.image = imageArr[frame]!;
    }
    @IBAction func playButton(_ sender: Any) {
        self.navigationController!.navigationBar.isHidden = false;
        isTitleScreen = false;
        timer!.invalidate();
    }

    
    @IBAction func unwindToAdvList(_ sender: UIStoryboardSegue) {
        print("went");
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
