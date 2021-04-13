//
//  BabyProfileEdit.swift
//  InfantoryApp
//
//  Created by Gilbert Nicholas on 12/04/21.
//

import UIKit

class BabyProfileEditController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageEditChild: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var babyInfo:Baby?
    
    var generatedPhotoName = ""
    var isChanged = false
    
    let genders = ["Boy", "Girl"]
    
    var items:[Baby]?
    
    var imagePicker = UIImagePickerController()
    let datePicker = UIDatePicker()
    var pickerView = UIPickerView()
    
    var dateOfBirth:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
        
        initData()
        
        makeImageRound()
        
        createDatePicker()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        genderField.inputView = pickerView
        
    }
    
    func initData() {
        nameField.text = babyInfo?.name
        genderField.text = babyInfo?.gender
        imageEditChild.image = getSavedImage(named: "\(babyInfo?.photo ?? "")")

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        birthdayField.text = formatter.string(from: babyInfo?.dateOfBirth ?? Date())
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if nameField.text == "" || birthdayField.text == "" || genderField.text == "" {
            let alert = UIAlertController(title: "Add Baby Data", message: "Add missing data!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            babyInfo?.name = nameField.text
            babyInfo?.gender = genderField.text
            if isChanged == true {
                babyInfo?.photo = generatedPhotoName
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            babyInfo?.dateOfBirth = dateFormatter.date(from: birthdayField.text ?? "")
            
            do{
                try self.context.save()
            }catch{
                print("error saving data")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addPhotoButton(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func makeImageRound() {
        imageEditChild.layer.masksToBounds = false
        imageEditChild.layer.borderColor = UIColor.black.cgColor
        imageEditChild.layer.cornerRadius = imageEditChild.frame.height/2
        imageEditChild.clipsToBounds = true
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
            }
            return nil
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageSelected = info[.editedImage] as? UIImage else {
            return
        }
        
        imageEditChild.image = imageSelected
        imageEditChild.contentMode = .scaleAspectFill
        imagePicker.dismiss(animated: true, completion: nil)
        
        generatedPhotoName = "\(randomNum()).png"
        isChanged = true
        
        saveImage(image: imageSelected, named: generatedPhotoName)
    }

    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path.first
    }

    func saveImage(image : UIImage, named: String) {
        if let pngData = image.pngData(),
        let path = documentDirectoryPath()?.appendingPathComponent(named) {
            try? pngData.write(to: path)
        }
    }
    
    func randomNum() -> String {
        var number = String()
        for _ in 1...8 {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolbar.setItems([doneBtn], animated: true)
        
        birthdayField.inputAccessoryView = toolbar
        
        birthdayField.inputView = datePicker
        
        datePicker.datePickerMode = .date
        
        datePicker.preferredDatePickerStyle = .wheels
        
    }
    
    @objc func donePressed() {
        dateOfBirth = datePicker.date
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        birthdayField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
}

extension BabyProfileEditController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = genders[row]
        genderField.resignFirstResponder()
    }
}
