//
//  prescriptions.swift
//  PrescribeIt
//
//  Created by Jaagrav Seal on 23/12/24.
//

import Foundation

class Vitals: ObservableObject {
    @Published var heartBpm: String
    @Published var bloodPressure: [String]
    @Published var age: String
    @Published var tempInF: String
    @Published var gender: Gender
    
    init(heartBpm: String, bloodPressure: [String], age: String, tempInF: String, gender: Gender) {
        self.heartBpm = heartBpm
        self.bloodPressure = bloodPressure
        self.age = age
        self.tempInF = tempInF
        self.gender = gender
    }
}

class Symptom: ObservableObject, Identifiable {
    @Published var description: String
    @Published var notes: String
    
    var uid: UUID
    
    init(description: String, notes: String) {
        self.description = description
        self.notes = notes
        self.uid = UUID()
    }
}

class MedicineSchedule: ObservableObject, Identifiable {
    @Published var hour: Int
    @Published var minutes: Int
    @Published var days: [String]
    @Published var isSOS: Bool
    
    init(hour: Int, minutes: Int, days: [String], isSOS: Bool) {
        self.hour = hour
        self.minutes = minutes
        self.days = days
        self.isSOS = isSOS
    }
}

class Medicine: ObservableObject, Identifiable {
    @Published var schedule: MedicineSchedule
    @Published var name: String
    @Published var quantity: String
    @Published var notes: String
    
    var uid: UUID
    
    init(schedule: MedicineSchedule, name: String, quantity: String, notes: String) {
        self.schedule = schedule
        self.name = name
        self.quantity = quantity
        self.notes = notes
        self.uid = UUID()
    }
}

class Prescription: ObservableObject, Identifiable {
    @Published var fullName: String
    @Published var vitals: Vitals
    @Published var createdAt: Date
    @Published var symptoms: [Symptom]
    @Published var medicines: [Medicine]
    
    var uid: UUID
    
    init(fullName: String) {
        self.fullName = fullName
        self.createdAt = Date.now
        self.uid = UUID()
        self.vitals = Vitals(heartBpm: "", bloodPressure: ["", ""], age: "", tempInF: "", gender: .male)
        self.symptoms = []
        self.medicines = []
    }

    init(fullName: String, vitals: Vitals, symptoms: [Symptom], medicines: [Medicine]) {
        self.fullName = fullName
        self.createdAt = Date.now
        self.uid = UUID()
        self.vitals = vitals
        self.symptoms = symptoms
        self.medicines = medicines
    }
}

class Prescriptions: ObservableObject {
    @MainActor static let shared = Prescriptions()
    
    @Published var prescriptions: [Prescription] = [
        Prescription(
            fullName: "Jaagrav Seal",
            vitals: Vitals(heartBpm: "92", bloodPressure: ["120", "80"], age: "21", tempInF: "98", gender: .male),
            symptoms: [
                Symptom(description: "Common cold", notes: "With runny nose and cough"),
                Symptom(description: "Mild fever", notes: ""),
            ],
            medicines: [
                Medicine(schedule: MedicineSchedule(hour: 10, minutes: 0, days: ["Monday"], isSOS: true), name: "Paracetamol", quantity: "650mg", notes: "Take in case fever crosses 102 fahrenheitz"),
                Medicine(schedule: MedicineSchedule(hour: 22, minutes: 30, days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], isSOS: false), name: "Cough Syrup", quantity: "2ml", notes: "Every night before sleeping"),
            ]
        )
    ]
    
    func createPrescription(prescription: Prescription) {
        self.prescriptions.append(prescription)
    }
    
    func savePrescription(prescription: Prescription) {
        for (index, item) in self.prescriptions.enumerated() {
            if prescription.uid == item.uid {
                self.prescriptions[index] = prescription
            }
        }
    }
}

enum Gender: String, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"
    case nonbinary = "Non-Binary"
    case other = "Other"

    var id: Self { self }
}
