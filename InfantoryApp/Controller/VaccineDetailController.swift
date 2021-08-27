//
//  VaccineDetailController.swift
//  InfantoryApp
//
//  Created by Gilbert Nicholas on 05/04/21.
//

import UIKit
import CoreData

class VaccineDetailController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var vaccineDetail: UILabel!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var vaccineIcon: UIImageView!
    @IBOutlet weak var dateIcon: UIImageView!
    
    let datePicker = UIDatePicker()
    
    var vaccine = Vaccine()
    
    var items:[Baby]?
    
    var dateVaccine = Date()
    var dateChanged = false
    
    var vaccineForDate: [VaccineRecieved] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateField.text = "mm/dd/yy"
        createDatePicker()
        
        initData()
        
        print(vaccine.isTrue)
        
        if vaccine.isTrue == true {
            print("initdate")
            initDate()
        }

        // Do any additional setup after loading the view.
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
        } catch {
    
        }
        return date
    }
    
    func initDate() {
        let vaccineDate = fetchDateFromCoreData(with: vaccine)
        
        dateField.text = vaccineDate
    }
    
    func initData() {
        vaccineDetail.text = vaccine.description
        navBar.topItem?.title = vaccine.name
        vaccineIcon.image = UIImage(named: vaccine.icon)
        dateIcon.image = UIImage(named: "iconVaccine")
    }
    
    //tutup modal
    @IBAction func CloseModal(_ sender: Any) {
        if vaccine.isTrue == false {
            do{
                let request = Baby.fetchRequest() as NSFetchRequest<Baby>
                let pred = NSPredicate(format: "isActive = true")
                request.predicate = pred
                
                self.items = try context.fetch(request)
                
                if dateChanged == true {
                    if self.items?.count ?? 0 > 0 {
                        let newVaccine = VaccineRecieved(context: context)
                        newVaccine.vaccineId = vaccine.id
                        newVaccine.date = dateVaccine
                
                        let baby = self.items![0]
                        baby.addToVaccineRecieved(newVaccine)
                        do{
                            try self.context.save()
                        }catch{
                            print("error saving data")
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Add Baby's Profile", message: "To insert vaccination date, please insert your baby's profile", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Not Now", style: UIAlertAction.Style.default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Update", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                            self.performSegue(withIdentifier: "babyProfileSegue", sender: self)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } catch{
                
            }
            
            self.dismiss(animated: true, completion: nil)

        } else {
            
        }
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolbar.setItems([doneBtn], animated: true)
        
        dateField.inputAccessoryView = toolbar
        
        dateField.inputView = datePicker
        
        datePicker.datePickerMode = .date
        
        datePicker.preferredDatePickerStyle = .wheels
        
    }
    
    @objc func donePressed() {
        dateVaccine = datePicker.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        dateChanged = true
        
        dateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadMonthData"), object: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
