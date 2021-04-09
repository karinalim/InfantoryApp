//
//  BabyProfileFormController.swift
//  InfantoryApp
//
//  Created by Gilbert Nicholas on 05/04/21.
//

import UIKit

class BabyProfileFormController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Navigation Bar Outlets
        @IBOutlet weak var addChildNavBar: UINavigationBar!
        
    // Add Photo Outlets
        @IBOutlet weak var imageAddChild: UIImageView!
        @IBOutlet weak var addPhotoButton: UIButton!
        
    // Label Outlets
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var birthdayLabel: UILabel!
        @IBOutlet weak var genderLabel: UILabel!
        
    // Text Field Outlets
        @IBOutlet weak var addBabyName: UITextField!
        @IBOutlet weak var birthdayLabelTwo: UITextField!
    
    let birthdayPicker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
        
        birthdayLabelTwo.text = ""
        createDatePicker()
        
    }
    
// Text Field Actions
    @IBAction func addBabyName(_ sender: Any) {
        
    }
    
//    @IBAction func birthdayField(_ sender: Any) {
        
//    }
    
//    @IBAction func genderPicker(_ sender: Any) {
        
//    }
    
// Navigation Bar Actions
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
// Add Photo Actions
    @IBAction func addPhotoButton(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageSelected = info[.editedImage] as? UIImage else {
            return
        }
        
        imageAddChild.image = imageSelected
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolbar.setItems([doneBtn], animated: true)
        
        birthdayLabelTwo.inputAccessoryView = toolbar
        
        birthdayLabelTwo.inputView = birthdayPicker
        
        birthdayPicker.datePickerMode = .date
        
        birthdayPicker.preferredDatePickerStyle = .wheels
        
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
        formatter.dateFormat = "MM/dd/yy"
//        formatter.timeStyle = .none
        
        birthdayLabelTwo.text = formatter.string(from: birthdayPicker.date)
        self.view.endEditing(true)
    }
    
//    func createBirthdayPicker() {
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        let doneButtonTwo = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector (doneButtonTwoPressed))
//
//        toolbar.setItems([doneButtonTwo], animated: true)
//
//        birthdayLabelTwo.inputAccessoryView = toolbar
//        birthdayLabelTwo.inputView = birthdayPicker
//        birthdayPicker.datePickerMode = .date
//        birthdayPicker.preferredDatePickerStyle = .wheels
//
//    }
//
//    @objc func doneButtonTwoPressed() {
//        let formatter = DateFormatter()
////        formatter.dateStyle = .medium
//        formatter.dateFormat = "dd/MM/yy"
////        formatter.timeStyle = .none
//
//        birthdayLabelTwo.text = formatter.string(from: birthdayPicker.date)
//        self.view.endEditing(true)
//    }
    
}
