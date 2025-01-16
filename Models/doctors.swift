//
//  doctors.swift
//  PrescribeIt
//
//  Created by Jaagrav Seal on 23/12/24.
//

import Foundation
import Combine

class Doctor: ObservableObject, Identifiable, Codable {
    @Published var uid: UUID
    @Published var fullName: String
    @Published var phoneNumber: String
    @Published var speciality: String
    
    init(fullName: String, phoneNumber: String, speciality: String) {
        self.uid = UUID()
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.speciality = speciality
    }
    
    enum CodingKeys: String, CodingKey {
        case fullName, phoneNumber, speciality, uid
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fullName = try container.decode(String.self, forKey: .fullName)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        speciality = try container.decode(String.self, forKey: .speciality)
        uid = try container.decode(UUID.self, forKey: .uid)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(speciality, forKey: .speciality)
        try container.encode(uid, forKey: .uid)
    }
    
    static func == (lhs: Doctor, rhs: Doctor) -> Bool {
        return lhs.uid == rhs.uid &&
        lhs.fullName == rhs.fullName &&
        lhs.phoneNumber == rhs.phoneNumber &&
        lhs.speciality == rhs.speciality
    }
}

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
    
    static func == (lhs: Vitals, rhs: Vitals) -> Bool {
        return lhs.age == rhs.age &&
        lhs.bloodPressure == rhs.bloodPressure &&
        lhs.tempInF == rhs.tempInF &&
        lhs.gender == rhs.gender &&
        lhs.heartBpm == rhs.heartBpm
    }
}

class Symptom: ObservableObject, Identifiable, Codable, Equatable {
    @Published var description: String
    @Published var notes: String

    var uid: UUID

    init(description: String, notes: String) {
        self.description = description
        self.notes = notes
        self.uid = UUID()
    }

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
    
    static func == (lhs: Symptom, rhs: Symptom) -> Bool {
        return lhs.uid == rhs.uid &&
            lhs.notes == rhs.notes &&
            lhs.description == rhs.description
    }
}

class MedicineSchedule: ObservableObject, Identifiable, Codable {
    @Published var daypart: [String]
    @Published var days: [String]
    @Published var isSOS: Bool

    init(daypart: [String], days: [String], isSOS: Bool) {
        self.daypart = daypart
        self.days = days
        self.isSOS = isSOS
    }
 
    enum CodingKeys: String, CodingKey {
        case daypart, days, isSOS
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        daypart = try container.decode([String].self, forKey: .daypart)
        days = try container.decode([String].self, forKey: .days)
        isSOS = try container.decode(Bool.self, forKey: .isSOS)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(daypart, forKey: .daypart)
        try container.encode(days, forKey: .days)
        try container.encode(isSOS, forKey: .isSOS)
    }
    
    static func == (lhs: MedicineSchedule, rhs: MedicineSchedule) -> Bool {
        return lhs.isSOS == rhs.isSOS &&
        lhs.days == rhs.days &&
        lhs.daypart == rhs.daypart
    }
}

class Medicine: ObservableObject, Identifiable, Codable, Equatable {
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
    
    static func == (lhs: Medicine, rhs: Medicine) -> Bool {
        return lhs.uid == rhs.uid &&
        lhs.notes == rhs.notes &&
        lhs.name == rhs.name &&
        lhs.quantity == rhs.quantity
    }
}

class Prescription: ObservableObject, Identifiable, Codable, Equatable {
    @Published var patientName: String
    @Published var doctor: Doctor
    @Published var vitals: Vitals
    @Published var createdAt: Date
    @Published var symptoms: [Symptom]
    @Published var medicines: [Medicine]

    var uid: UUID

    init(patientName: String, doctor: Doctor, vitals: Vitals, symptoms: [Symptom], medicines: [Medicine]) {
        self.patientName = patientName
        self.createdAt = Date.now
        self.uid = UUID()
        self.vitals = vitals
        self.symptoms = symptoms
        self.medicines = medicines
        self.doctor = doctor
    }
    
    init(uid: UUID, patientName: String, doctor: Doctor, createdAt: Date, vitals: Vitals, symptoms: [Symptom], medicines: [Medicine]) {
        self.patientName = patientName
        self.doctor = doctor
        self.createdAt = createdAt
        self.uid = uid
        self.vitals = vitals
        self.symptoms = symptoms
        self.medicines = medicines
    }

    enum CodingKeys: String, CodingKey {
        case patientName, doctor, vitals, createdAt, symptoms, medicines, uid
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        patientName = try container.decode(String.self, forKey: .patientName)
        doctor = try container.decode(Doctor.self, forKey: .doctor)
        vitals = try container.decode(Vitals.self, forKey: .vitals)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        symptoms = try container.decode([Symptom].self, forKey: .symptoms)
        medicines = try container.decode([Medicine].self, forKey: .medicines)
        uid = try container.decode(UUID.self, forKey: .uid)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(patientName, forKey: .patientName)
        try container.encode(doctor, forKey: .doctor)
        try container.encode(vitals, forKey: .vitals)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(symptoms, forKey: .symptoms)
        try container.encode(medicines, forKey: .medicines)
        try container.encode(uid, forKey: .uid)
    }
    
    static func == (lhs: Prescription, rhs: Prescription) -> Bool {
        return lhs.uid == rhs.uid &&
                lhs.patientName == rhs.patientName &&
                lhs.createdAt == rhs.createdAt &&
                lhs.symptoms == rhs.symptoms &&
                lhs.medicines == rhs.medicines
    }
}

class Prescriptions: ObservableObject {
    @MainActor static let shared = Prescriptions()
    
    @Published var prescriptions: [Prescription] = [] {
        didSet {
            saveToUserDefaults()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        loadFromUserDefaults()
    }
    
    func createPrescription(prescription: Prescription) {
        self.prescriptions.append(prescription)
    }
    
    func savePrescription(prescription: Prescription) {
        for (index, item) in self.prescriptions.enumerated() {
            if prescription.uid == item.uid {
                self.prescriptions[index] = prescription
                return
            }
        }
    }
    
    func deletePrescription(prescription: Prescription) {
        self.prescriptions.removeAll { $0.uid == prescription.uid }
    }
    
    private func saveToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(prescriptions)
            UserDefaults.standard.set(data, forKey: "prescriptions")
        } catch {
            print("Failed to save prescriptions to UserDefaults: \(error)")
        }
    }
    
    private func loadFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "prescriptions") else { return }
        do {
            let loadedPrescriptions = try JSONDecoder().decode([Prescription].self, from: data)
            self.prescriptions = loadedPrescriptions
        } catch {
            print("Failed to load prescriptions from UserDefaults: \(error)")
        }
    }
}
