//
//  doctors.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 26/12/24.
//

import Foundation

class Doctor: User {
    @Published var speciality: String
    init(firstName: String, lastName: String, speciality: String, phoneNumber: String) {
        self.speciality = speciality
        super.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, userType: "doctor")
    }
}
