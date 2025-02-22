//
//  PrescriptionListItem.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 30/12/24.
//

import SwiftUI

struct PrescriptionItem: View {
    @Binding var prescription: Prescription
    var isActive: Bool
    @ObservedObject var sharedUser = AppState.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(prescription.createdAt.formatted(.dateTime.year().month().day().hour().minute()))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    if isActive {
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
                    if prescription.isSample == true {
                        Text("SAMPLE")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.trailing, -8)
                            .padding(.leading, 6)
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
    }
}

struct PrescriptionListItem: View {
    @Binding var prescription: Prescription
    @StateObject var sharedPrescriptions = Prescriptions.shared
    @State var selectedPage: String?
    @ObservedObject var sharedUser = AppState.shared
    
    var notificationManager = NotificationManager.shared
    @State var activePrescription: Prescription? = nil
    
    @Binding var path: NavigationPath
    
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            if #available(iOS 18, *) {
                PrescriptionItem(prescription: $prescription, isActive: activePrescription?.uid == prescription.uid)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray3), lineWidth: 1)
                            .padding(.vertical, 1)
                    }
                    .padding(.horizontal, 24)
                    .matchedTransitionSource(id: "prescription-\(prescription.uid)", in: namespace)
            } else {
                PrescriptionItem(prescription: $prescription, isActive: activePrescription?.uid == prescription.uid)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray3), lineWidth: 1)
                            .padding(.vertical, 1)
                    }
                    .padding(.horizontal, 24)
            }
        }
        .onTapGesture {
            if path.count == 0 {
                path.append(prescription.uid.uuidString)
            }
        }
        .onAppear {
            activePrescription = notificationManager.getActivePrescriptionSynchronously(allPrescriptions: sharedPrescriptions.prescriptions)
        }
    }
}
