//
//  PrescriptionPreview.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 26/12/24.
//

import SwiftUI

struct PrescriptionPreview: View {
    @StateObject var prescription: Prescription
    
    @ObservedObject var sharedUser = AppState.shared
    
    var withPadding: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Dr \(prescription.doctorName)")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text(prescription.speciality)
                            .font(.footnote)
                            .fontWeight(.medium)
                    }
                    Spacer()
                    Image(systemName: "pills.circle.fill")
                        .font(.largeTitle)
                }
                Divider()
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Patient Name: \(prescription.patientName)")
                                .font(.caption2)
                            Text("Age: \(prescription.vitals.age) years • Gender: \(prescription.vitals.gender.rawValue.capitalized) • Pulse: \(prescription.vitals.heartBpm)bpm • Blood Pressure: \(prescription.vitals.bloodPressure[0])/\(prescription.vitals.bloodPressure[1])mmHg")
                                .font(.caption2)
                            Divider()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Chief Complaints")
                                .font(.caption)
                                .fontWeight(.medium)
                            Divider()
                                .padding(.top, -6)
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach($prescription.symptoms) { $symptom in
                                    VStack(alignment: .leading) {
                                        Text(symptom.description)
                                            .font(.caption2)
                                        if symptom.notes != "" {
                                            Text("Notes: \(symptom.notes)")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 6)
                                    
                                    Divider()
                                }
                            }
                            .padding(.top, -16)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Prescribed Medicines")
                                .font(.caption)
                                .fontWeight(.medium)
                            Divider()
                                .padding(.top, -6)
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach($prescription.medicines) { $medicine in
                                    VStack(alignment: .leading) {
                                        Text(medicine.name)
                                            .font(.caption2)
                                        Text("\(getMedicineScheduleString(medicine: medicine))\(getMedicineScheduleString(medicine: medicine) != "" && medicine.quantity != "" ? "• " : "")\(medicine.quantity)")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                        if medicine.notes != "" {
                                            Text("Notes: \(medicine.notes)")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 6)
                                    
                                    Divider()
                                }
                            }
                            .padding(.top, -16)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text("Date: \(prescription.createdAt.formatted(.dateTime.year().month().day().hour().minute()))")
                                .font(.caption2)
                            Spacer()
                            Text("Signature")
                                .font(.caption2)
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding(8)
        .padding(withPadding ? 8 : 0)
    }
}
