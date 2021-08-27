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
    
    var activeBaby: Baby?
    
    var vaccineCoreData:VaccineRecieved?
    
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
        
        self.title = month.name
        
        initData()
            
        initCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func loadList(notification: NSNotification){
        allVaccineMonth = []
        trueVaccine = []
        falseVaccine = []
        usedArray = []
        
        initData()
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
    
    func fetchActiveBaby(){
        do {
            let fetchRequest = Baby.fetchRequest() as NSFetchRequest<Baby>
            fetchRequest.predicate = NSPredicate(format: "isActive == true")
            fetchRequest.relationshipKeyPathsForPrefetching = ["vaccineRecieved"]
            let babies = try context.fetch(fetchRequest)
            if(babies.count > 0){
                self.activeBaby = babies[0]
                self.collectionView.reloadData()
            }
        } catch {
            
        }
    }
    
    func initData() {
        fetchActiveBaby()

        allVaccineMonth = Vaccine.sortVaccine(month.id)
        
        if activeBaby != nil {
            let vaccineReceivedList = (self.activeBaby?.vaccineRecieved) as! Set<VaccineRecieved>
            
            let today = Date()
            var temp: [Vaccine] = []

            for var vm in allVaccineMonth {
                var flag = -1
                for inputed in vaccineReceivedList {
                    
                    if(vm.id == inputed.vaccineId) {
                        
                        if(today.compare(inputed.date!) == ComparisonResult.orderedAscending) {
                            vm.isTrue = false
                            flag = 0
                            temp.append(vm)
                        }
                        else if (today.compare(inputed.date!) == ComparisonResult.orderedDescending) {
                            vm.isTrue = true
                            flag = 0
                            temp.append(vm)
                        }
                    }
                }
                if flag == -1 {
                    temp.append(vm)
                }
            }
            allVaccineMonth.removeAll()
            allVaccineMonth = temp
        }
        
        for vaccine in allVaccineMonth {
            
            if vaccine.isTrue == true {
                trueVaccine.append(vaccine)
            } else {
                falseVaccine.append(vaccine)
            }
        }
        
        usedArray = falseVaccine
    }
    
    func initCollectionView() {
        collectionView.register(VaccineMonthCell.nib(), forCellWithReuseIdentifier: "VaccineMonthCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func fetchDateFromCoreData(with curr:Vaccine) -> String {
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

            else {
                date = "mm/dd/yy"
            }

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {

        }
//        if activeBaby != nil {
//            let vaccineReceivedList = (self.activeBaby?.vaccineRecieved) as! Set<VaccineRecieved>
//            var flag = false
//
//            for vaccine in vaccineReceivedList {
//                if vaccine.vaccineId == selectedVaccine.id {
//                    vaccineCoreData = vaccine
//
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "MM/dd/yy"
//                    date = formatter.string(from: vaccine.date!)
//
//                    flag = true
//                    print("flag true")
//                    break
//                }
//            }
//
//            if flag == false {
//                print("flag false")
//                date = "mm/dd/yy"
//            }
//        } else {
//            print("no baby")
//            date = "mm/dd/yy"
//        }
//
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
        
        return date
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
        let vaccineDate = fetchDateFromCoreData(with: currVaccine)
        
        cell.setName(with: currVaccine.name)
        cell.vaccineIcon.image = UIImage(named: currVaccine.icon)
        
        cell.setDate(with: vaccineDate)
        
        cell.layer.cornerRadius = 8.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 360, height: 70)
    }
    
    //    Move Segue Function
    //    ============================================================================
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "VaccineDetailSegue"){
            let destinationVC = segue.destination as? VaccineDetailController
            destinationVC?.vaccine = selectedVaccine
        }
    }
}
