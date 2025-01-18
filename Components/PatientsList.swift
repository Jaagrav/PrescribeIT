//
//  PatientsList.swift
//  PrescribeIt
//
//  Created by Jaagrav Seal on 23/12/24.
//

import SwiftUI

struct PatientsList: View {
    @ObservedObject var sharedPrescriptions = Prescriptions.shared
    
    var searchText: String
    
    var body: some View {
        VStack {
            Text("Recent Patients")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 12)
            if sharedPrescriptions.prescriptions.isEmpty {
                VStack {
                    VStack {
                        Image("NoPatients")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                            .padding(.top, 0)
                            .padding(.bottom, 12)
                        Text("No recent patients")
                            .font(.title3)
                        Text("Press on the bottom right plus button in order to add a new patient to create their prescription")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 300)
                            .padding(.top, 4)
                    }
                    .opacity(0.6)
                }
                .frame(height: UIScreen.main.bounds.height / 2)
            }
            ForEach($sharedPrescriptions.prescriptions.filter({ $presc in
                searchText.isEmpty || presc.patientName.lowercased().contains(searchText.lowercased())
            })) { $prescription in
                PatientListItem(prescription: $prescription)
            }
        }
    }
}
