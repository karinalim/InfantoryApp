//
//  VaccineListController.swift
//  InfantoryApp
//
//  Created by Gilbert Nicholas on 05/04/21.
//

import UIKit

class VaccineListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let months: [Month] = Month.generateAllMonth()
    var selectedMonth = Month()

    @IBOutlet weak var vaccineListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vaccineListTableView.dataSource = self
        vaccineListTableView.delegate  = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "vaccineListTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! VaccineListTableViewCell
        let currMonth = months[indexPath.row]
        cell.iconMonth.image = UIImage(named: currMonth.icon)
        cell.monthTitle.text = currMonth.name
        cell.vaccineList.text = getVaccines(vaccineList: currMonth.vaccineList)
        cell.overdueLabel.text = ""
        //TODO: Create function to get completed & overdue status
        if(indexPath.row == 1){
            cell.overdueLabel.text = "!"
        }
        //TODO: Create function to sync with baby age to get colored icon
//        if(month.isCurrent){
//            cell.iconMonth.tintColor = UIColor.primary
//        }
        return cell
    }
    
    func getVaccines(vaccineList: [Vaccine]) -> String{
        var vaccines: String = ""
        if(vaccineList.count <= 0){
            return "No Vaccine"
        }
        for vaccine in vaccineList {
            let vaccineName: String = vaccine.name + " Vaccine"
            if vaccines == "" {
                vaccines = vaccineName
            }
            vaccines = vaccines + ", " + vaccineName
        }
        return vaccines
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMonth = months[indexPath.row]
        self.performSegue(withIdentifier: "VaccineListMonthSegue", sender: self)
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "VaccineListMonthSegue"){
            let destinationVC = segue.destination as? VaccineListMonthController
            destinationVC?.month = selectedMonth
        }
    }
}
