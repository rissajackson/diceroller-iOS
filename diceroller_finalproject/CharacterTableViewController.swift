//
//  CharacterTableViewController.swift
//  diceroller_finalproject
//
//  Created by Tristan Hsieh on 11/13/19.
//  Copyright © 2019 Razerware. All rights reserved.
//

import UIKit
import CoreData

var charArr: [NSManagedObject] = [];
var focusCharacter: NSManagedObject!;

class CharacterTableViewController: UITableViewController {
    @IBOutlet weak var diceButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext

        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "CharacterInd")

        self.loadData(managedContext: managedContext,fetchRequest: fetchRequest);
        
        if(charArr.count > 0){
            diceButton.isEnabled = true;
        }
    }
    
    func loadData(managedContext: NSManagedObjectContext,fetchRequest: NSFetchRequest<NSManagedObject>){
        do {
            charArr = try managedContext.fetch(fetchRequest);
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return charArr.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterTableViewCell

        // Configure the cell...
        cell.nameLabel.text! = charArr[indexPath.row].value(forKeyPath: "name") as! String;
        cell.classLabel.text! = "Class: \(charArr[indexPath.row].value(forKeyPath: "charClass") as! String)"
        cell.hpLabel.text! = "HP: \(charArr[indexPath.row].value(forKeyPath: "hp") as! Int32)/\(charArr[indexPath.row].value(forKeyPath: "totalHp") as! Int32)"
        cell.profPic.image = UIImage(data:charArr[indexPath.row].value(forKeyPath: "image") as! Data,scale:1.0)!;
        cell.characterObject = charArr[indexPath.row];

        return cell
    }
    
    func disableButton(){
        diceButton.isEnabled = false;
    }
    
    @IBAction func unwindToAdvList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? AddCharacterViewController {
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext =
              appDelegate.persistentContainer.viewContext

            let fetchRequest =
              NSFetchRequest<NSManagedObject>(entityName: "CharacterInd")
            
            self.loadData(managedContext: managedContext, fetchRequest: fetchRequest);
            
            let newIndexPath = IndexPath(row: charArr.count - 1, section: 0);
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            diceButton.isEnabled = true;
        }
        
        tableView.reloadData();
        do {
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext =
              appDelegate.persistentContainer.viewContext
            
            try managedContext.save()
        }
        catch {
            print("Error Saving")
        }
        /*charArr.append(focusCharacter);
        let newIndexPath = IndexPath(row: charArr.count - 1, section: 0);
        tableView.insertRows(at: [newIndexPath], with: .automatic);*/
    }
    @IBAction func deleteButtonReload(_ sender: Any) {
        // You want the cells to go away when your done...
        tableView.reloadData();
        if(charArr.count == 0){
            diceButton.isEnabled = false;
        }
    }
    
    
    
    //MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(focusCharacter);
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
