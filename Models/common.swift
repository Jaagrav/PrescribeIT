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
    @Published var userType: String
    
    init(firstName: String, lastName: String, phoneNumber: String, userType: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.userType = userType
    }
}

class SharedUser: ObservableObject {
    @MainActor static let shared = SharedUser()
    
    @Published var user = Doctor(firstName: "John", lastName: "Doe", speciality: "Cardiologist", phoneNumber: "+9183758203843")
}
