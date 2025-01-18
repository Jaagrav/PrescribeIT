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
        ScrollView {
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
                    .buttonStyle(.plain)
                }
            }
            else {
                VStack {
                    VStack {
                        Image("NoPatients")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                            .padding(.top, 0)
                            .padding(.bottom, 12)
                        Text("No active prescription")
                            .font(.title3)
                        Text("Your list of medicines for your active medicine prescription schedule will appear here")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 300)
                            .padding(.top, 4)
                    }
                    .opacity(0.6)
                }
                .frame(height: UIScreen.main.bounds.height / 2)
            }
        }
        .onAppear {
            activePrescription = notificationManager.getActivePrescriptionSynchronously(allPrescriptions: sharedPrescriptions.prescriptions)
        }
    }
}

#Preview {
    ActivePrescription()
}
