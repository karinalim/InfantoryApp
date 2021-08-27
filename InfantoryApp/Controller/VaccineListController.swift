//
//  VaccineListController.swift
//  InfantoryApp
//
//  Created by Gilbert Nicholas on 05/04/21.
//

import UIKit
import CoreData

class VaccineListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var months: [Month] = Month.generateAllMonth()
    var selectedMonth = Month()
    var activeBaby: Baby?
    var currentMonthId = -1

    @IBOutlet weak var vaccineListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchActiveBaby()
        // Do any additional setup after loading the view.
//        vaccineListTableView.dataSource = self
//        vaccineListTableView.delegate  = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchActiveBaby()
        vaccineListTableView.dataSource = self
        vaccineListTableView.delegate  = self
//        print(activeBaby)
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
        //TODO: Create function to get completed & overdue status -- CANT FETCH VACCINE RECEIVED FROM CORE DATA
        if(currMonth.isOverdue && !currMonth.isCompleted){
            cell.overdueLabel.text = "!"
        }
        else if (currMonth.isOverdue && currMonth.isCompleted){
            cell.vaccineList.text = "Completed"
            cell.vaccineList.tintColor = UIColor.primary
        }
        //Create function to sync with baby age to get colored icon
        if(currMonth.isCurrent){
            cell.iconMonth.image = UIImage(named: "green_\(currMonth.icon)")
        }
        return cell
    }
    
    func getVaccines(vaccineList: [Vaccine]) -> String{
        var vaccines: String = ""
        if(vaccineList.count <= 0){
            return "No Vaccine"
        }
        for vaccine in vaccineList {
            if vaccines == "" {
                vaccines = vaccine.name
            }
            else{
                vaccines = vaccines + ", " + vaccine.name
            }
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
    
    func fetchActiveBaby(){
        do {
            let fetchRequest = Baby.fetchRequest() as NSFetchRequest<Baby>
            fetchRequest.predicate = NSPredicate(format: "isActive == true")
            fetchRequest.relationshipKeyPathsForPrefetching = ["vaccineRecieved"]
            let babies = try context.fetch(fetchRequest)
            if(babies.count > 0){
                self.activeBaby = babies[0]
                self.getCurrentMonth((self.activeBaby?.dateOfBirth)!)
                setCurrentMonth(currentMonthId)
                self.vaccineListTableView.reloadData()
            }
            
        } catch {
            
        }
    }
    
    func setCurrentMonth(_ id: Int){
        var temp:[Month] = []
        for var mo in months{
            mo.isCurrent = false
            mo.isCompleted = false
            mo.isOverdue = false
            if(mo.id == id){
                mo.isCurrent = true
            }
            else if(mo.id < id){
                mo.isOverdue = true
                mo = checkIfCompleted(mo)
            }
            temp.append(mo)
//            print("\(mo.id): \(mo.isCurrent)")
        }
        months.removeAll()
        months = temp
    }
    
    func checkIfCompleted(_ month: Month)-> Month {
        //TODO: get core data vaccine received here
        var newMonth = month
        let vaccineReceivedList = (self.activeBaby?.vaccineRecieved)! as! Set<VaccineRecieved>
//        print(vaccineReceivedList)
        var vrMonthList: [Vaccine] = []
        let today = Date()
        for var vm in newMonth.vaccineList {
            for inputed in vaccineReceivedList {
                if(vm.id != inputed.vaccineId) {continue}
                if(today.compare(inputed.date!) == ComparisonResult.orderedAscending){
                    vm.isTrue = false
                }
                else{
                    vm.isTrue = true
                }
                vrMonthList.append(vm)
            }
        }
        if(month.vaccineList.count == vrMonthList.count){
            newMonth.isCompleted = true
        }
        else{
            newMonth.isCompleted = false
        }
        return newMonth
    }
    
//    func getCurrentMonthVaccineReceived(_ month: Month) -> Set<VaccineRecieved>{
//        let vaccineReceivedList = (self.activeBaby?.vaccineRecieved)! as! Set<VaccineRecieved>
//        let resultList = []
//        for vm in month.vaccineList{
//            let findVR = vaccineReceivedList.filter($ == vm.id)
//            if
//        }
//    }
    
    
    func getCurrentMonth(_ babyDOB: Date){
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 2
        form.unitsStyle = .full
        form.allowedUnits = [.month]
        let s = form.string(from: babyDOB, to: Date())
        currentMonthId = getMonthIdOnly(s ?? "0 month")
    }
    
    func getMonthIdOnly(_ currentMonth: String) -> Int{
        let stringArr: [String.SubSequence] = currentMonth.split(separator: " ")
        return Int(stringArr[0]) ?? 0
    }
    
//    func setProfileImage(){
//        let img: UIImage = UIImage.init(named: "\(activeBaby.babyPhoto)") ?? UIImage.init(systemName: "person.fill") as! UIImage
//        let imgView: UIImageView = makeImageRound()
//        imgView.image = img
//        imgView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        let rightBtn: UIBarButtonItem = UIBarButtonItem.init(customView: imgView)
//        self.navigationItem.rightBarButtonItem = rightBtn;
//    }
//
//    func makeImageRound() -> UIImageView{
//        let view = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        view.layer.masksToBounds = true;
//        view.layer.borderColor = UIColor.black.cgColor
//        view.layer.cornerRadius = view.frame.height/2
//        view.clipsToBounds = true
//        return view
//    }
}
