//
//  common.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 26/12/24.
//

import Foundation

class User: ObservableObject {
    @Published var firstName: String
    @Published var lastName: String
    @Published var phoneNumber: String
    @Published var userType: UserType
    @Published var speciality: String
    @Published var age: String
    @Published var gender: Gender
    
    init(firstName: String, lastName: String, phoneNumber: String, userType: UserType, speciality: String = "", age: String = "", gender: Gender = .male) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.userType = userType 
        self.speciality = speciality
        self.age = age
        self.gender = gender
    }
}

enum AppLevel {
case onboarding, loggedin
}

@MainActor
class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var user: User? = User(firstName: "Jaagrav", lastName: "Seal", phoneNumber: "1234567890", userType: .patient, age: "21", gender: .male)
    
    @Published var appState: AppLevel = .onboarding
}

// AppState.shared.user = User(firstName: "Jaagrav", lastName: "Seal", phoneNumber: "1234567890", userType: .patient, age: "21", gender: .male)
