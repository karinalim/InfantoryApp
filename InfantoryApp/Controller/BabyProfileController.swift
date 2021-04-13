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
    
    @IBOutlet weak var colView: UICollectionView!
    
    func fetchBaby() {
        do {
            self.items = try context.fetch(Baby.fetchRequest())
            
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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        
        cell.setDOB(with: "\(formatter.string(from: baby.dateOfBirth!))")
        cell.layer.cornerRadius = 10.0
        
        return cell
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
                
                print(self.babies?.count)
            } catch{
                
            }
            for babyy in self.babies! as [Baby] {
                babyy.isActive = false
            }
            baby.isActive = true
        }))
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
            print("Edit")
            
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
            
            let baby = self.items![0]
            
            baby.isActive = true
        } catch {
            
        }
    }
}
