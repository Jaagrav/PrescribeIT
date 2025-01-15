//
//  PrescriptionsList.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 30/12/24.
//

import SwiftUI

struct PrescriptionsList: View {
    @ObservedObject var sharedPrescriptions = Prescriptions.shared
    var body: some View {
        VStack(spacing: 22) {
            if sharedPrescriptions.prescriptions.isEmpty {
                Text("No prescriptions saved yet")
            }
            ForEach(sharedPrescriptions.prescriptions) { prescription in
                PrescriptionListItem(prescription: prescription)
            }
        }
        .padding(.top, -12)
    }
}
