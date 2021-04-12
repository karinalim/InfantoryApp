//
//  BabyProfileController.swift
//  InfantoryApp
//
//  Created by Gilbert Nicholas on 05/04/21.
//

import UIKit

class BabyProfileController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Baby]?
    
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
        
        self.performSegue(withIdentifier: "BabyProfileFormSegue", sender: self)
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
}
