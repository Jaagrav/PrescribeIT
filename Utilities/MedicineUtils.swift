//
//  MedicineUtils.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 26/12/24.
//

import Foundation

func getMedicineScheduleString(medicine: Medicine) -> String {
    var formattedDays: String = "", finalMessage: String = ""
    if medicine.schedule.days.count == 7 {
        formattedDays = "Everyday"
    } else {
        formattedDays = medicine.schedule.days
            .map({ day in
                day.prefix(3)
            })
            .joined(separator: ", ")
    }
    
    let dayparts = ["Morning", "Afternoon", "Evening", "Night"]
    var formattedDaypart: String = ""
    formattedDaypart = dayparts
        .filter({ part in
            medicine.schedule.daypart.contains(part)
        })
        .joined(separator: ", ")
    
    if formattedDays != "" {
        finalMessage += "\(formattedDays)"
    }
    
    if formattedDaypart != "" {
        finalMessage +=  " in the \(formattedDaypart)"
    }
    
    if medicine.schedule.isSOS {
        if finalMessage != "" {
            finalMessage = "SOS • " + finalMessage
        } else {
            finalMessage = "SOS"
        }
    }
    
    return finalMessage
}
