//
//  PrescriptionBuilderView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 25/12/24.
//

import SwiftUI

struct PrescriptionBuilderView: View {
    @Binding var prescription: Prescription
    @State var showDeletePrescription: Bool = false
    
    var body: some View {
        List {
            Section("Patient Name") {
                TextField("e.g. Jaagrav Seal", text: $prescription.patientName)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding(.vertical, 12)
            }
            
            Section("General Information") {
                HStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("Heart Rate (bpm)")
                            .font(.caption)
                        HStack {
                            TextField("90", text: $prescription.vitals.heartBpm)
                                .keyboardType(.numberPad)
                                .font(.title)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Blood Pressure (mmHg)")
                            .font(.caption)
                        HStack {
                            TextField("120", text: $prescription.vitals.bloodPressure[0])
                                .keyboardType(.numberPad)
                                .font(.title)
                            Text("/")
                                .font(.title)
                            TextField("80", text: $prescription.vitals.bloodPressure[1])
                                .keyboardType(.numberPad)
                                .font(.title)
                        }
                    }
                }
                .padding(.vertical, UIDevice.current.userInterfaceIdiom == .phone ? 0 : 12)
                
                HStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("Age (years)")
                            .font(.caption)
                        HStack {
                            TextField("21", text: $prescription.vitals.age)
                                .keyboardType(.numberPad)
                                .font(.title)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Gender")
                            .font(.caption)
                        HStack {
                            Picker("Gender", selection: $prescription.vitals.gender) {
                                Text("Male")
                                    .tag(Gender.male)
                                Text("Female")
                                    .tag(Gender.female)
                                Text("Non-binary")
                                    .tag(Gender.nonbinary)
                                Text("Other")
                                    .tag(Gender.other)
                            }
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.tertiary, lineWidth: 1)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, UIDevice.current.userInterfaceIdiom == .phone ? 6 : 12)
            }
            
            Section("Chief Complaints") {
                SymptomsList(symptoms: $prescription.symptoms)
                    .padding(.vertical, 12)
            }
            
            Section("Suggested Medicines") {
                MedicinesList(medicines: $prescription.medicines)
                    .padding(.vertical, 12)
            }
            
            Button("Delete Patient", systemImage: "trash", role: .destructive) {
                showDeletePrescription = true
            }
            .foregroundColor(.red)
            .padding(.vertical, 12)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Patient Details")
        .toolbar {
            NavigationLink {
                GeneratePrescriptionView(prescription: prescription)
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .fontWeight(.medium)
                        .foregroundColor(.accentColor)
                }
            }
            .buttonStyle(.plain)
        }
        .alert("You are about to delete \(prescription.patientName)'s prescription", isPresented: $showDeletePrescription) {
            Button("Cancel", role: .cancel) {
                showDeletePrescription = false
            }
            Button("Delete", role: .destructive) {
                Prescriptions.shared.deletePrescription(prescription: prescription)
            }
        }
    }
}

//#Preview {
//    PrescriptionBuilderView(prescription: Prescription(
//            patientName: "Jaagrav Seal",
//            doctorName: "Sushan Mukhopadhyay",
//            speciality: "Cardiologist",
//            vitals: Vitals(heartBpm: "92", bloodPressure: ["120", "80"], age: "21", tempInF: "98", gender: .male),
//            symptoms: [
//                Symptom(description: "Common cold", notes: "With runny nose and cough"),
//                Symptom(description: "Mild fever", notes: ""),
//            ],
//            medicines: [
//                Medicine(schedule: MedicineSchedule(daypart: ["Afternoon", "Night"], days: ["Monday"], isSOS: true), name: "Paracetamol", quantity: "650mg", notes: "Take in case fever crosses 102 fahrenheitz"),
//                Medicine(schedule: MedicineSchedule(daypart: ["Night"], days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], isSOS: false), name: "Cough Syrup", quantity: "2ml", notes: "Every night before sleeping"),
//            ]
//        )
//    )
//}
