//
//  BabyProfileEdit.swift
//  InfantoryApp
//
//  Created by Gilbert Nicholas on 12/04/21.
//

import UIKit

class BabyProfileEditController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var baby: Baby?
    var items:[Baby]?
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var babyPhotoEdit: UIImageView!
    
    @IBOutlet weak var babyNameEdit: UILabel!
    
    @IBOutlet weak var babyDobEdit: UILabel!
    
    @IBOutlet weak var babyGenderEdit: UILabel!
    
    @IBOutlet weak var babyNameFieldEdit: UITextField!

    @IBOutlet weak var babyDobFieldEdit: UITextField!
    
    @IBOutlet weak var babyGenderFieldEdit: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func fetchBaby() {
        
    }
    
    @IBAction func babyPhotoEditBtn(_ sender: UIButton) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageSelected = info[.editedImage] as? UIImage else {
            return
        }
        
        babyPhotoEdit.image = imageSelected
        babyPhotoEdit.contentMode = .scaleAspectFill
        imagePicker.dismiss(animated: true, completion: nil)
        
        let generatedPhotoName = baby?.photo ?? ""
        
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
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
            }
            return nil
    }
    
    @IBAction func babyEditDoneBtn(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func babyEditnCancelBtn(_ sender: UIBarButtonItem) {
        
    }
}



