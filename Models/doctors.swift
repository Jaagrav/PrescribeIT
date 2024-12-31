//
//  doctors.swift
//  PrescribeIt
//
//  Created by Jaagrav Seal on 23/12/24.
//

import Foundation

class Vitals: ObservableObject, Codable {
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

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case heartBpm, bloodPressure, age, tempInF, gender
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        heartBpm = try container.decode(String.self, forKey: .heartBpm)
        bloodPressure = try container.decode([String].self, forKey: .bloodPressure)
        age = try container.decode(String.self, forKey: .age)
        tempInF = try container.decode(String.self, forKey: .tempInF)
        gender = try container.decode(Gender.self, forKey: .gender)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(heartBpm, forKey: .heartBpm)
        try container.encode(bloodPressure, forKey: .bloodPressure)
        try container.encode(age, forKey: .age)
        try container.encode(tempInF, forKey: .tempInF)
        try container.encode(gender.rawValue, forKey: .gender)
    }
}

class Symptom: ObservableObject, Identifiable, Codable {
    @Published var description: String
    @Published var notes: String

    var uid: UUID

    init(description: String, notes: String) {
        self.description = description
        self.notes = notes
        self.uid = UUID()
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case description, notes, uid
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decode(String.self, forKey: .description)
        notes = try container.decode(String.self, forKey: .notes)
        uid = try container.decode(UUID.self, forKey: .uid)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        try container.encode(notes, forKey: .notes)
        try container.encode(uid, forKey: .uid)
    }
}

class MedicineSchedule: ObservableObject, Identifiable, Codable {
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

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case hour, minutes, days, isSOS
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hour = try container.decode(Int.self, forKey: .hour)
        minutes = try container.decode(Int.self, forKey: .minutes)
        days = try container.decode([String].self, forKey: .days)
        isSOS = try container.decode(Bool.self, forKey: .isSOS)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hour, forKey: .hour)
        try container.encode(minutes, forKey: .minutes)
        try container.encode(days, forKey: .days)
        try container.encode(isSOS, forKey: .isSOS)
    }
}

class Medicine: ObservableObject, Identifiable, Codable {
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

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case schedule, name, quantity, notes, uid
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        schedule = try container.decode(MedicineSchedule.self, forKey: .schedule)
        name = try container.decode(String.self, forKey: .name)
        quantity = try container.decode(String.self, forKey: .quantity)
        notes = try container.decode(String.self, forKey: .notes)
        uid = try container.decode(UUID.self, forKey: .uid)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schedule, forKey: .schedule)
        try container.encode(name, forKey: .name)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(notes, forKey: .notes)
        try container.encode(uid, forKey: .uid)
    }
}

class Prescription: ObservableObject, Identifiable, Codable {
    @Published var patientName: String
    @Published var doctorName: String
    @Published var speciality: String
    @Published var vitals: Vitals
    @Published var createdAt: Date
    @Published var symptoms: [Symptom]
    @Published var medicines: [Medicine]

    var uid: UUID

    init(patientName: String, doctorName: String, speciality: String, vitals: Vitals, symptoms: [Symptom], medicines: [Medicine]) {
        self.patientName = patientName
        self.doctorName = doctorName
        self.createdAt = Date.now
        self.uid = UUID()
        self.vitals = vitals
        self.symptoms = symptoms
        self.medicines = medicines
        self.speciality = speciality
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case patientName, doctorName, speciality, vitals, createdAt, symptoms, medicines, uid
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        patientName = try container.decode(String.self, forKey: .patientName)
        doctorName = try container.decode(String.self, forKey: .doctorName)
        speciality = try container.decode(String.self, forKey: .speciality)
        vitals = try container.decode(Vitals.self, forKey: .vitals)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        symptoms = try container.decode([Symptom].self, forKey: .symptoms)
        medicines = try container.decode([Medicine].self, forKey: .medicines)
        uid = try container.decode(UUID.self, forKey: .uid)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(patientName, forKey: .patientName)
        try container.encode(doctorName, forKey: .doctorName)
        try container.encode(vitals, forKey: .vitals)
        try container.encode(speciality, forKey: .speciality)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(symptoms, forKey: .symptoms)
        try container.encode(medicines, forKey: .medicines)
        try container.encode(uid, forKey: .uid)
    }
}

class Prescriptions: ObservableObject {
    @MainActor static let shared = Prescriptions()
    
    @Published var prescriptions: [Prescription] = [
        Prescription(
            patientName: "Jaagrav Seal",
            doctorName: "Sushan Mukhopadhyay",
            speciality: "Cardiologist",
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

enum Gender: String, CaseIterable, Identifiable, Codable {
    case male = "Male"
    case female = "Female"
    case nonbinary = "Non-Binary"
    case other = "Other"

    var id: Self { self }
}
