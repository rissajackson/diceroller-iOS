//
//  CharacterTableViewCell.swift
//  diceroller_finalproject
//
//  Created by Tristan Hsieh on 11/13/19.
//  Copyright © 2019 Razerware. All rights reserved.
//

import UIKit
import CoreData

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var profPic: UIImageView!
    var characterObject: NSManagedObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        focusCharacter = self.characterObject;

        // Configure the view for the selected state
    }
    @IBAction func deleteButton(_ sender: Any) {
        do {
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext =
              appDelegate.persistentContainer.viewContext
            
            managedContext.delete(characterObject!)
            
            charArr.remove(at: charArr.firstIndex(of: characterObject!)!);
            
            try managedContext.save()
            
        }
        catch {
            print("Error Deleting")
        }
    }
    
}
