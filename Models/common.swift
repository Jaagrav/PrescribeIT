//
//  common.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 26/12/24.
//

import Foundation
import Combine

enum UserType: String, CaseIterable, Identifiable, Codable {
    case doctor, patient
    var id: Self { self }
}

enum Gender: String, CaseIterable, Identifiable, Codable {
    case male = "Male"
    case female = "Female"
    case nonbinary = "Non-Binary"
    case other = "Other"

    var id: Self { self }
}

class User: ObservableObject, Codable {
    @Published var firstName: String
    @Published var lastName: String
    @Published var phoneNumber: String
    @Published var userType: UserType
    @Published var speciality: String
    @Published var age: String
    @Published var gender: Gender
    
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, phoneNumber, userType, speciality, age, gender
    }
    
    init(firstName: String, lastName: String, phoneNumber: String, userType: UserType, speciality: String = "", age: String = "", gender: Gender = .male) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.userType = userType 
        self.speciality = speciality
        self.age = age
        self.gender = gender
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.userType = try container.decode(UserType.self, forKey: .userType)
        self.speciality = try container.decode(String.self, forKey: .speciality)
        self.age = try container.decode(String.self, forKey: .age)
        self.gender = try container.decode(Gender.self, forKey: .gender)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(userType, forKey: .userType)
        try container.encode(speciality, forKey: .speciality)
        try container.encode(age, forKey: .age)
        try container.encode(gender, forKey: .gender)
    }
}

enum AppLevel: String, Codable {
case onboarding, authorised
}

class AppState: ObservableObject {
    @MainActor static let shared = AppState()
    
    @Published var user: User? {
        didSet {
            saveUserToDefaults()
        }
    }
    
    @Published var appLevel: AppLevel = .onboarding {
        didSet {
            saveAppLevelToDefaults()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        loadUserFromDefaults()
    }
    
    private func saveUserToDefaults() {
        guard let user = user else { return }
        do {
            let userData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(userData, forKey: "user")
        } catch {
            print("Failed to save user to UserDefaults: \(error)")
        }
    }
    
    private func saveAppLevelToDefaults() {
        UserDefaults.standard.set(appLevel.rawValue, forKey: "appLevel")
        print("Save \(appLevel.rawValue)")
    }
    
    private func loadUserFromDefaults() {
        guard let userData = UserDefaults.standard.data(forKey: "user") else { return }
        do {
            let loadedUser = try JSONDecoder().decode(User.self, from: userData)
            self.user = loadedUser
        } catch {
            print("Failed to load user from UserDefaults: \(error)")
        }
        
        
        if let appLevelString = UserDefaults.standard.string(forKey: "appLevel") {
            print("loadUserFromDefaults \(appLevelString)")
            
            self.appLevel = AppLevel(rawValue: appLevelString)!
        }
    }
}

// AppState.shared.user = User(firstName: "Jaagrav", lastName: "Seal", phoneNumber: "1234567890", userType: .patient, age: "21", gender: .male)
