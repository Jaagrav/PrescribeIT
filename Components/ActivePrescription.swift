//
//  ActivePrescription.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 01/01/25.
//

import SwiftUI

struct ActivePrescription: View {
    @StateObject var sharedPrescriptions = Prescriptions.shared
    var notificationManager = NotificationManager.shared
    @State var activePrescription: Prescription? = nil
    
    var body: some View {
        VStack {
            if activePrescription != nil {
                VStack(spacing: 24) {
                    ForEach(activePrescription?.medicines ?? []) { medicine in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(medicine.name)
                                    .fontWeight(.medium)
                                Text("\(medicine.quantity)\(getMedicineScheduleString(medicine: medicine) != "" && medicine.quantity != "" ? " • " : "")\(getMedicineScheduleString(medicine: medicine))")
                                    .font(.caption)
                                if medicine.notes != "" {
                                    Text("Notes: \(medicine.notes)")
                                        .font(.footnote)
                                }
                                Text("Prescribed by **Dr \(activePrescription?.doctor.fullName ?? "")**")
                                    .font(.footnote)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray3), lineWidth: 1)
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    NavigationLink {
                        GeneratePrescriptionView(prescription: activePrescription!)
                    } label: {
                        HStack {
                            Text("See full prescription")
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .padding(.horizontal, 24)
                    }
                }
            }
            else {
                VStack {
                    Spacer()
                    Text("No active prescription yet")
                    Spacer()
                }
            }
        }
        .padding(.top, -12)
        .onAppear {
            activePrescription = notificationManager.getActivePrescriptionSynchronously(allPrescriptions: sharedPrescriptions.prescriptions)
        }
    }
}

#Preview {
    ActivePrescription()
}
