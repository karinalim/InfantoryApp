//
//  GrowthController.swift
//  InfantoryApp
//
//  Created by Gilbert Nicholas on 05/04/21.
//

import UIKit
import CoreData



class GrowthController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var monthSelected : Int = 0
    var currentMonth : Int = 0
    var monthInfoSelected : Int!
    var isActive : Bool!
    var babyName :String?
    var babyDOB : Date?
    var babyId : String = ""
  
    
    @IBOutlet weak var growthCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return growthModel.generateDummy().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let growthCell = collectionView.dequeueReusableCell(withReuseIdentifier: "growthCell", for: indexPath) as! GrowthCollectionViewCell
        
        growthCell.configGrowthCell(with: (indexPath.row) )
        if  indexPath.row == currentMonth {
            growthCell.backgroundColor = UIColor.white
            growthCell.layer.cornerRadius = growthCell.bounds.width/2
            growthCell.layer.borderColor = UIColor.primary?.cgColor
            growthCell.layer.borderWidth = 5
           
        } else {growthCell.backgroundColor = UIColor.white
            growthCell.layer.cornerRadius = growthCell.bounds.width/2
            growthCell.layer.borderColor = UIColor.systemGray5.cgColor
            growthCell.layer.borderWidth = 5
        }; if monthSelected == indexPath.row {
            growthCell.layer.cornerRadius = growthCell.bounds.width/2
//            growthCell.layer.borderColor = UIColor.systemGray5.cgColor
            growthCell.layer.borderWidth = 5
            growthCell.backgroundColor = UIColor.secondary
            
        }
//        ;
//        if monthSelected == indexPath.row && indexPath.row == monthSelected{
//            growthCell.backgroundColor = UIColor.white
//            growthCell.layer.cornerRadius = growthCell.bounds.width/2
//            growthCell.backgroundColor = UIColor.secondary
//            growthCell.layer.borderWidth = 5
//        }
////        growthCell.backgroundColor = UIColor.white
//        growthCell.layer.cornerRadius = growthCell.bounds.width/2
//        growthCell.layer.borderWidth = 5
//        growthCell.layer.borderColor = UIColor.primary?.cgColor
        
//        if monthSelected == indexPath.row {
//            growthCell.backgroundColor = UIColor.secondary
//        } else {
//            growthCell.backgroundColor = UIColor.clear
//        }
//
        return growthCell
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBabyData()
        growthCollectionView.reloadData()
        monthSelected = currentMonth
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    
//    growthView Manager
    
    @IBOutlet weak var growthIconImage1: UIImageView!
    
//    Image Configuration
    @IBOutlet weak var growthIconImage2: UIImageView!
    var  imagePickerGrowth = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setGrowthInfo()
        
        growthCollectionView.dataSource = self
        growthCollectionView.delegate = self
        
        imagePickerGrowth.delegate = self
        imagePickerGrowth.allowsEditing = true
//        ini apa artinya?
        imagePickerGrowth.mediaTypes = ["public.image"]
        fetchBabyData()
        growthCollectionView.reloadData()
//        toMonth()
    }
    
//    try trigger function in Collection View
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fetchBabyData()
       
    }
    
    @IBOutlet weak var growthScrollView: UIScrollView!
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var bottomView : UIView!
    @IBOutlet weak var growthTableLabel : UILabel!
    @IBOutlet weak var growthTitle : UINavigationItem!
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 80)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
//        print(indexPath.row)
        self.monthSelected = indexPath.row
//
        
        self.setGrowthInfo()
        self.growthCollectionView.reloadData()
        self.fetchBabyData()
//        self.toMonth()
    }
    
 

    
    func setUI() {
//        UI setup
        growthTitle.title = "Growth"
        
        
//        addPhotoButtonLook.setTitle("Add Baby's Growth Photo", for: .normal)
        addPhotoButtonLook.setTitleColor(UIColor.primary, for: .normal)
        
        growthScrollView.backgroundColor = UIColor.systemGray6
        
        bgView.backgroundColor = UIColor.systemGray6
        
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width/2
      
        growthIconImage1.image = UIImage(named: "growthEmoji")
    
        growthIconImage2.image = UIImage(named: "graphGrowth")
        
        bottomView.layer.cornerRadius = 20
        bottomView.backgroundColor = UIColor.white
        growthTableLabel.text = "Growth"
        growthTableLabel.textColor = UIColor.primary
        growthTableLabel.font = UIFont.boldSystemFont(ofSize: 27)
        
        if let layout = growthCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    //    set data for growth info
    let growthData : [growthModel] = growthModel.generateDummy()
    
    
    @IBAction func addPhotoButton(_ sender: Any) {
    }
    
    @IBOutlet weak var addPhotoButtonLook:UIButton!
    
    func setGrowthInfo() {
        introLabel.text = growthData[monthSelected ].intro
        descriptionLabel.text = growthData[monthSelected
        ].description
        
        introLabel.numberOfLines = 0
        introLabel.font = UIFont(name: "Arial", size: 17)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: "Arial", size: 17)
        descriptionLabel.sizeToFit()
      
        
        if getSavedImage(named: "\(babyId)selected\(monthSelected).png") != nil {
            let catchedImage = getSavedImage(named: "\(babyId)selected\(monthSelected).png")
            profileImage.image = catchedImage
            profileImage.contentMode = .scaleAspectFill
            addPhotoButtonLook.setTitle("Edit Photo", for: .normal)
            
            
        } else {
            profileImage.image = UIImage(systemName: "plus.circle")
            profileImage.tintColor = UIColor.primary
            addPhotoButtonLook.setTitle("Add Photo", for: .normal)
            
        }
    }
    
//    Add Photo Action
    
    @IBAction func addGrowthPhoto (_ sender: Any) {
        self.present(imagePickerGrowth, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageSelected = info[.editedImage] as? UIImage else {
            return
        }
        
        profileImage.image = imageSelected
        profileImage.contentMode = .scaleAspectFill
        imagePickerGrowth.dismiss(animated: true, completion: nil)
        
//        works
        saveImage(image: imageSelected, named: "\(babyId)selected\(monthSelected).png")
        let cathedImage = getSavedImage(named: "\(babyId)selected\(monthSelected).png")
        profileImage.image = cathedImage
       
      
    }
    
//     try saved Image to test
//   trial aman
    
  
    
    
//set directory path func
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path.first
    }
    
    //      try to save image
    func saveImage(image : UIImage, named: String) {
        if let pngData = image.pngData(),
               let path = documentDirectoryPath()?.appendingPathComponent(named) {
               try? pngData.write(to: path)
           }
    }
    
//    try to get image
    
    func getSavedImage(named: String) ->UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
           }
           return nil
    }
    
    var items:[Baby]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
 
    
    
    func fetchBabyData() {
//        let babyData = Baby(context: context)
        do{
            let request = Baby.fetchRequest() as NSFetchRequest<Baby>
            let pred = NSPredicate(format: "isActive = true")
            request.predicate = pred
            self.items = try context.fetch(request)
            
            if self.items?.count != 0 {
                let baby = self.items![0]
                self.babyName = baby.name ?? ""
//                let date = Date()
                self.babyDOB = baby.dateOfBirth!
                
                self.currentMonth = Date().months(sinceDate: babyDOB!)!
                let shortenId = baby.babyId?.prefix(8) ?? ""
                self.babyId = String("\(shortenId)")
                print(shortenId)
                print(self.babyId)
                print(self.currentMonth)
                
// to month
                
//                to inspect
//                ===========
                
//                print(baby.dateOfBirth!)
//                print(baby.name!)
                
    }
        }catch{
        
        }}
    
 
    
    
//    func toMonth() {
////        print (Date().months(sinceDate: babyDOB!) ?? 1)
//
//        guard currentMonth == Date().months(sinceDate: babyDOB!) else {
//            return
//        }
//        print(currentMonth!)
//    }
    
   
       
}


extension Date {

    func months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }


}


