//
//  AddCharacterViewController.swift
//  diceroller_finalproject
//
//  Created by Tristan Hsieh on 11/13/19.
//  Copyright © 2019 Razerware. All rights reserved.
//

import UIKit
import CoreData

class AddCharacterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var peasantButton: UIButton!
    @IBOutlet weak var knightButton: UIButton!
    @IBOutlet weak var wizardButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var profImage: UIImageView!
    
    @IBOutlet weak var addCharacterButton: UIButton!
    
    var selectedClass = "Peasant";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameField.delegate = self;
    }
    
    func textFieldShouldReturn(_ nameField: UITextField) -> Bool {
        nameField.resignFirstResponder();
        nameLabel.text! = "Name: \(nameField.text!)";
        return true;
    }

    //UI ImagePickerControllerDelegate
    func imagePickerControllerDidCancel (_ picker: UIImagePickerController){
        //Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        guard let selectedImage = info[.originalImage] as?
            UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following \(info)")
        }
        profImage.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CharacterInd", in: context)
        let newChar = NSManagedObject(entity: entity!, insertInto: context)
        
        newChar.setValue(nameField.text!, forKey: "name")
        newChar.setValue(selectedClass, forKey: "charClass")
        newChar.setValue(30, forKey: "hp")
        newChar.setValue(30, forKey: "totalHp")
        newChar.setValue(profImage.image!.pngData(), forKey: "image")

    }
    
    @IBAction func peasantAction(_ sender: Any) {
        selectedClass = "Peasant";
        updateClassText();
    }
    @IBAction func knightAction(_ sender: Any) {
        selectedClass = "Knight";
        updateClassText();
    }
    @IBAction func wizardAction(_ sender: Any) {
        selectedClass = "Wizard";
        updateClassText();
    }
    @IBAction func addCharacterAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func selectImageFromPhotoLibrary(_ sender: Any) {
        // Hide the keyboard.
        nameField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController,animated: true,completion: nil)
    }
    
    
    func updateClassText(){
        classLabel.text! = "Class: \(selectedClass)";
    }
}
