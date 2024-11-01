//
//  DateUtility.swift
//  App-RK-BM
//
//  Created by Luis Mora on 31/10/24.
//

import Foundation

class DateUtility {
    static func getCurrentDate() -> (year: String, month: String, dayNumber: String, dayName: String) {
        let date = Date()
        let calendar = Calendar.current
        
        let year1 = calendar.component(.year, from: date).description.capitalized
        let dayNumber1 = calendar.component(.day, from: date).description.capitalized
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        
        dateFormatter.dateFormat = "MMMM"
        let monthName1 = dateFormatter.string(from: date).capitalized
        dateFormatter.dateFormat = "EEEE"
        let dayName1 = dateFormatter.string(from: date).capitalized
        
        return (year: year1, month: monthName1, dayNumber: dayNumber1, dayName: dayName1)
    }
}
