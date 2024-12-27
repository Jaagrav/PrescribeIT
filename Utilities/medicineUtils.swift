//
//  medicineUtils.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 26/12/24.
//

import Foundation

func getMedicineScheduleString(medicine: Medicine) -> String {
    let dayNames = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
    ]
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mm a"
    
    var components = DateComponents()
    components.hour = medicine.schedule.hour
    components.minute = medicine.schedule.minutes
    let calendar = Calendar.current
    let date = calendar.date(from: components) ?? Date()
    let formattedTime = timeFormatter.string(from: date)
    
    var formattedDays: String = ""
    if medicine.schedule.days.count == 7 {
        formattedDays = "Everyday"
    } else {
        formattedDays = medicine.schedule.days
            .map({ day in
                day.prefix(3)
            })
            .joined(separator: ", ")
    }
    
    if medicine.schedule.hour == -1 && medicine.schedule.minutes == -1 {
        return "\(formattedDays)\(formattedDays != "" ? " • " : "")\(medicine.schedule.isSOS ? "SOS " : "")"
    }
    
    return "\(formattedDays) at \(formattedTime) \(medicine.schedule.isSOS ? "• SOS " : "")"
}
