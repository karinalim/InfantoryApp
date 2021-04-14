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
    
    let datePicker = UIDatePicker()
    
    var vaccine = Vaccine()
    
    var items:[Baby]?
    
    var dateVaccine = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateField.text = "mm/dd/yy"
        createDatePicker()
        
        initData()

        // Do any additional setup after loading the view.
    }
    
    func initData() {
        vaccineDetail.text = vaccine.description
        navBar.topItem?.title = vaccine.name
        print(vaccine.name)
    }
    
    @IBAction func CloseModal(_ sender: Any) {
        let newVaccine = VaccineRecieved(context: context)
        newVaccine.vaccineId = vaccine.id
        newVaccine.date = dateVaccine
        
        do{
            let request = Baby.fetchRequest() as NSFetchRequest<Baby>
            let pred = NSPredicate(format: "isActive = true")
            request.predicate = pred
            
            self.items = try context.fetch(request)
            
            if self.items?.count != 0 {
                let baby = self.items![0]
                baby.addToVaccineRecieved(newVaccine)
//                newVaccine.baby = baby
            }
        } catch{
            
        }
        
        do{
            try self.context.save()
        }catch{
            print("error saving data")
        }

        self.dismiss(animated: true, completion: nil)
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
        
        dateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadMonthData"), object: nil)
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
