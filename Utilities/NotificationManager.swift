//
//  NotificationManager.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 05/01/25.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    @MainActor static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    let weekdays = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
    ]
    
    let dayParts = [
        "Morning",
        "Afternoon",
        "Evening",
        "Night"
    ]
    
    func getHourByDayPart(dayPart: String) -> Int {
        switch dayPart {
        case "Morning":
            return 9
        case "Afternoon":
            return 13
        case "Evening":
            return 18
        case "Night":
            return 21
        default:
            return -1
        }
    }
    
    func scheduleNotification(prescription: Prescription) {
        for (medIndex, medicine) in prescription.medicines.enumerated() {
            for (weekdayIndex, weekday) in medicine.schedule.days.enumerated() {
                let content = UNMutableNotificationContent()
                content.title = "Time to take \(medicine.name) \(medicine.quantity)"
                content.body = medicine.notes
                content.sound = .default
                
                for (dayPartIndex, dayPart) in medicine.schedule.daypart.enumerated() {
                    var dateComponents = DateComponents()
                    dateComponents.hour = self.getHourByDayPart(dayPart: dayPart)
                    dateComponents.minute = 00
                    dateComponents.weekday = self.weekdays.firstIndex(of: weekday)! + 1
                    
                    let identifier = "\(prescription.uid)-\(medicine.uid)-\(weekday)-\(dayPart)"
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling notification \(identifier) for weekday \(weekday): \(error.localizedDescription)")
                        } else {
                            print("Notification \(identifier) scheduled for weekday \(weekday).")
                        }
                    }
                }
            }
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("Notification received in foreground: \(notification.request.content.title)")
        completionHandler([.banner, .sound])
    }
    
    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled!")
            }
        }
    }
    
    func getPendingNotifications(completion: @escaping ([String]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiers = requests.map { $0.identifier }
            completion(identifiers)
        }
    }
    
    func unscheduleNotifications(identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        print("Canceled notifications: \(identifiers)")
    }
    
    func unscheduleAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All notifications unscheduled.")
    }
    
    func listAllScheduledNotifications() {
        getPendingNotifications { identifiers in
            print("Scheduled Notifications: \(identifiers)")
        }
    }
    
    func requestPermission(callback: @escaping @MainActor () -> Void) -> Void {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting notification permissions: \(error.localizedDescription)")
                }
                callback()
            }
        }
    }
    
    func getActivePrescriptionSynchronously(allPrescriptions: [Prescription]) -> Prescription? {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Prescription? = nil
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let ids = requests.map { $0.identifier }
            if !ids.isEmpty {
                for prescription in allPrescriptions {
                    let notiPrescId = ids[0].split(separator: "-").prefix(5).joined(separator: "-")
                    
                    if let extractedUUID = UUID(uuidString: notiPrescId) {
                        if extractedUUID == prescription.uid {
                            result = prescription
                            break
                        }
                    }
                }
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return result
    }
}
