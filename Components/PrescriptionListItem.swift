//
//  PrescriptionListItem.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 30/12/24.
//

import SwiftUI

struct PrescriptionListItem: View {
    @Binding var prescription: Prescription
    @StateObject var sharedPrescriptions = Prescriptions.shared
    
    @ObservedObject var sharedUser = AppState.shared
    
    var notificationManager = NotificationManager.shared
    @State var activePrescription: Prescription? = nil
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: sharedUser.user?.userType == .doctor ? AnyView(PrescriptionBuilderView(prescription: $prescription)) : AnyView(GeneratePrescriptionView(prescription: prescription))
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
                        
                        Text(sharedUser.user?.userType == .patient ? "Dr \(prescription.doctor.fullName)" : prescription.patientName)
                            .lineLimit(1)

                        Text("\(sharedUser.user?.userType == .patient ? prescription.doctor.speciality : "\(prescription.vitals.age) years old • \(prescription.vitals.gender.rawValue)") • \(prescription.medicines.count) Medicines • \(prescription.symptoms.count) Symptoms")
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
