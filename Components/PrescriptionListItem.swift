//
//  PrescriptionListItem.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 30/12/24.
//

import SwiftUI

struct PrescriptionListItem: View {
    @ObservedObject var prescription: Prescription
    @StateObject var sharedPrescriptions = Prescriptions.shared
    
    var notificationManager = NotificationManager.shared
    @State var activePrescription: Prescription? = nil
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: GeneratePrescriptionView(prescription: prescription)
            ) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(prescription.createdAt.formatted(.dateTime.year().month().day().hour().minute()))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            if activePrescription?.uid == prescription.uid {
                                Text("Active")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .padding(.trailing, -8)
                            }
                        }
                        
                        Text("Dr \(prescription.doctor.fullName)")
                            .lineLimit(1)
                        
                        Text("\(prescription.doctor.speciality) • \(prescription.medicines.count) Medicines • \(prescription.symptoms.count) Symptoms")
                            .font(.caption)
                            .opacity(0.6)
                            .padding(.top, 0.25)
                    }
                    .foregroundColor(.primary)
                    Spacer()
                }
                .onAppear {
                    activePrescription = notificationManager.getActivePrescriptionSynchronously(allPrescriptions: sharedPrescriptions.prescriptions)
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
        }
        .buttonStyle(.plain)
    }
}
