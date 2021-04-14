//
//  VaccineListMonthController.swift
//  InfantoryApp
//
//  Created by Gilbert Nicholas on 05/04/21.
//

import UIKit
import CoreData

class VaccineListMonthController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var segmentedControl: UISegmentedControl!

    var allVaccineMonth: [Vaccine] = []
    var trueVaccine: [Vaccine] = []
    var falseVaccine: [Vaccine] = []
    
    var vaccines:[VaccineRecieved]?
    var babies:[Baby]?
    
    var arrTrue: [Int] = []
    var arrFalse: [Int] = []

    var month: Month = Month()
    var usedArray: [Vaccine] = []
    
    var selectedVaccine = Vaccine()
    
    var vaccineForDate: [VaccineRecieved] = []
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.selectedSegmentIndex = 0
        
        initData()
        
        self.title = month.name
        
        initCollectionView()
    }
    
    func fetchDate() -> String {
//        do {
//            self.items = try context.fetch(Baby.fetchRequest())
//
//            DispatchQueue.main.async {
//                self.colView.reloadData()
//            }
//        } catch {
//
//        }
    }
    
    func fetchData(with curr:Vaccine) -> String {
        var date = ""
        do{
            let request = VaccineRecieved.fetchRequest() as NSFetchRequest<VaccineRecieved>
            let pred = NSPredicate(format: "vaccineId == \(curr.id)")
            request.predicate = pred

            self.vaccineForDate = try context.fetch(request)

            if self.vaccineForDate.count != 0 {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yy"
                date = formatter.string(from: vaccineForDate[0].date!)

            }
//            let request = Baby.fetchRequest() as NSFetchRequest<Baby>
//            let pred = NSPredicate(format: "isActive = true")
//            request.predicate = pred
//
//            self.babies = try context.fetch(request)
//
//            self.vaccines = babies[0].va
            
            
            else {
                date = "mm/dd/yy"
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
    
        }
        return date
    }
    
    //    IBAction Function
    //    ============================================================================
    
    @IBAction func sortVaccine(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            usedArray = falseVaccine
        } else {
            usedArray = trueVaccine
        }
        collectionView.reloadData()
    }
    
    //    Initialize Page
    //    ============================================================================
    
    func initData() {
        for vac in vaccineForDate {
            setDateTrueFalse(vaccine: vac)
        }
        
        for vaccine in allVaccineMonth {
            for tru in arrTrue {
                if vaccine.id == tru {
                    trueVaccine.append(vaccine)
                }
            }
        }
        
        for vaccine in allVaccineMonth {
            for fal in arrFalse {
                if vaccine.id == fal {
                    falseVaccine.append(vaccine)
                }
            }
        }
        
//        allVaccineMonth = Vaccine.sortVaccine(month.id)
//
//        for vaccine in allVaccineMonth {
//            if vaccine.isTrue == true {
//                trueVaccine.append(vaccine)
//            } else {
//                falseVaccine.append(vaccine)
//            }
//        }
        
        usedArray = falseVaccine
    }
    
    func initCollectionView() {
        collectionView.register(VaccineMonthCell.nib(), forCellWithReuseIdentifier: "VaccineMonthCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
//    Collection View Function
//    ============================================================================
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.selectedVaccine = usedArray[indexPath.row]
        
        self.performSegue(withIdentifier: "VaccineDetailSegue", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VaccineMonthCell", for: indexPath) as! VaccineMonthCell
        
        let currVaccine = usedArray[indexPath.row]
        let vaccineDate = fetchData(with: currVaccine)
        
        cell.setName(with: currVaccine.name)
        cell.vaccineIcon.image = UIImage(named: currVaccine.icon)
        
        cell.setDate(with: vaccineDate)
        
        cell.layer.cornerRadius = 8.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 360, height: 70)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "VaccineDetailSegue"){
            let destinationVC = segue.destination as? VaccineDetailController
            destinationVC?.vaccine = selectedVaccine
        }
    }
    
    func setDateTrueFalse(vaccine: VaccineRecieved) {
        let days = Date().compareDate(from: vaccine.date!, only: .day)
        
        let months = Date().compareDate(from: vaccine.date!, only: .month)
        
        let years = Date().compareDate(from: vaccine.date!, only: .year)
        
        if days > 0 || months > 0 || years > 0 {
            
            arrTrue.append(Int(vaccine.vaccineId))
        } else {
            arrFalse.append(Int(vaccine.vaccineId))
        }
    }
}

extension Date {

    func compareDate(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }
}
