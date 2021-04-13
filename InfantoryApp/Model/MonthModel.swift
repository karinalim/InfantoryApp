//
//  MonthModel.swift
//  InfantoryApp
//
//  Created by Karin Lim on 06/04/21.
//

import Foundation

struct Month{
    var id: Int = -1
    var icon: String = ""
    var name: String = ""
    var vaccineList: [Vaccine] = []
    var isCompleted: Bool = false
    var isOverdue: Bool = false
    var isCurrent: Bool = false
    
    static func generateAllMonth() -> [Month]{
        return monthList
    }
    
    static func getMonth(_ id: Int) -> Month{
        let idx: Int = id - 1
        return monthList[idx]
    }
    
}

var monthList:[Month] = [
    Month(id: 0, icon:"icon_month_0", name: "New Born", vaccineList: Vaccine.sortVaccine(0)),
    Month(id: 1, icon:"icon_month_1", name: "First Month", vaccineList: Vaccine.sortVaccine(1)),
    Month(id: 2, icon:"icon_month_2", name: "Second Month", vaccineList: Vaccine.sortVaccine(2)),
    Month(id: 3, icon:"icon_month_3", name: "Third Month", vaccineList: Vaccine.sortVaccine(3)),
    Month(id: 4, icon:"icon_month_4", name: "Forth Month", vaccineList: Vaccine.sortVaccine(4)),
    Month(id: 5, icon:"icon_month_5", name: "Fifth Month", vaccineList: Vaccine.sortVaccine(5)),
    Month(id: 6, icon:"icon_month_6", name: "Sixth Month", vaccineList: Vaccine.sortVaccine(6)),
    Month(id: 7, icon:"icon_month_7", name: "Seventh Month", vaccineList: Vaccine.sortVaccine(7)),
    Month(id: 8, icon:"icon_month_8", name: "Eighth Month", vaccineList: Vaccine.sortVaccine(8)),
    Month(id: 9, icon:"icon_month_9", name: "Ninth Month", vaccineList: Vaccine.sortVaccine(9)),
    Month(id: 10, icon:"icon_month_10", name: "Tenth Month", vaccineList: Vaccine.sortVaccine(10)),
    Month(id: 11, icon:"icon_month_11", name: "Eleventh Month", vaccineList: Vaccine.sortVaccine(11)),
    Month(id: 12, icon:"icon_month_12", name: "Twelfth Month", vaccineList: Vaccine.sortVaccine(12)),
]
