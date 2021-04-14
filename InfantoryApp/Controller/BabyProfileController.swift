//
//  BabyProfileController.swift
//  InfantoryApp
//
//  Created by Gilbert Nicholas on 05/04/21.
//

import UIKit
import CoreData

class BabyProfileController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let context2 = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Baby]?
    var babies:[Baby]?
    
    var babySend:Baby?
    
    @IBOutlet weak var colView: UICollectionView!
    
    func fetchBaby() {
        do {
            let req = Baby.fetchRequest() as NSFetchRequest<Baby>
            
            let sort = NSSortDescriptor(key: "dateOfBirth", ascending: false)
            req.sortDescriptors = [sort]
            
            self.items = try context.fetch(req)
            
            DispatchQueue.main.async {
                self.colView.reloadData()
            }
        } catch {
            
        }
    }

    @IBAction func tapToAddBaby() {
        self.performSegue(withIdentifier: "BabyProfileFormSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchBaby()
        initColView()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
    }
    
    @objc func loadList(notification: NSNotification){
        fetchBaby()
    }
    
//    Initialize Page
//    ============================================================================
    
    func initColView() {
        colView.register(BabyProfileCell.nib(), forCellWithReuseIdentifier: "BabyProfileCell")
        colView.delegate = self
        colView.dataSource = self
    }
    
//    Collection View Function
//    ============================================================================
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let baby = self.items![indexPath.row]
        showActionSheet(baby: baby)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BabyProfileCell", for: indexPath) as! BabyProfileCell
        
        let baby = self.items![indexPath.row]
        
        cell.setName(with: "\(baby.name ?? "")")
        cell.setGender(with: "\(baby.gender ?? "")")
        cell.babyPhoto.image = getSavedImage(named: "\(baby.photo ?? "")")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        
        cell.setDOB(with: "\(formatter.string(from: baby.dateOfBirth!))")
        cell.layer.cornerRadius = 10.0
        
        if baby.isActive == true {
            setBorderOn(with: cell)
        } else {
            setBorderOff(with: cell)
        }
        
        return cell
    }

    public func setBorderOn(with cell:BabyProfileCell) {
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0.5782148242, blue: 0.6328265667, alpha: 0.8470588235)
        cell.layer.borderWidth = 4
    }

    public func setBorderOff(with cell:BabyProfileCell) {
        cell.layer.borderColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1).cgColor
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
            }
            return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 354, height: 175)
    }
    
    func showActionSheet(baby: Baby) {
        let actionSheet = UIAlertController(title: "Baby Profile", message: baby.name, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
            print("Dismiss")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose", style: .default, handler: { action in
            print("Choose")
            do{
                let request = Baby.fetchRequest() as NSFetchRequest<Baby>
                let pred = NSPredicate(format: "isActive = true")
                request.predicate = pred
                
                self.babies = try self.context2.fetch(request)
            } catch{
                
            }
            for babyy in self.babies! as [Baby] {
                babyy.isActive = false
            }
            baby.isActive = true
            self.fetchBaby()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
            print("Edit")
            self.babySend = baby
            self.performSegue(withIdentifier: "BabyProfileEditSegue", sender: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            print("Delete")
            self.context.delete(baby)
            do{
                try self.context.save()
            } catch {
    
            }
            self.selectActiveBaby()
            self.fetchBaby()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func selectActiveBaby() {
        do {
            self.items = try context.fetch(Baby.fetchRequest())
            /Users/gilbertnicholas/Documents/Xcode/InfantoryApp/InfantoryApp/Controller/BabyProfileController.swift
            let baby = self.items![0]
            
            baby.isActive = true
        } catch {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "BabyProfileEditSegue"){
            let destinationVC = segue.destination as? BabyProfileEditController
            destinationVC?.babyInfo = babySend
        }
    }
}
