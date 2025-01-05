//
//  PatientsList.swift
//  PrescribeIt
//
//  Created by Jaagrav Seal on 23/12/24.
//

import SwiftUI

struct PatientsList: View {
    @ObservedObject var sharedPrescriptions = Prescriptions.shared
    
    var body: some View {
        VStack {
            Text("Recent Patients")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 12)
            if sharedPrescriptions.prescriptions.isEmpty {
                Text("No patient prescriptions yet")
            }
            ForEach($sharedPrescriptions.prescriptions) { $prescription in
                PatientListItem(prescription: $prescription)
            }
        }
    }
}
