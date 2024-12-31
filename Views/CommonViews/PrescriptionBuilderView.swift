//
//  PrescriptionBuilderView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 25/12/24.
//

import SwiftUI

struct PrescriptionBuilderView: View {
    @StateObject var prescription: Prescription
    
    var body: some View {
        List {
            Section("Patient Name") {
                TextField("e.g. Jaagrav Seal", text: $prescription.patientName)
                    .font(.largeTitle)
                    .fontWeight(.medium)
            }
            
            Section("General Information") {
                HStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("Heart Rate (bpm)")
                            .font(.subheadline)
                        HStack {
                            TextField("90", text: $prescription.vitals.heartBpm)
                                .keyboardType(.numberPad)
                                .font(.title)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Blood Pressure (mmHg)")
                            .font(.subheadline)
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
                
                HStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("Age (years)")
                            .font(.subheadline)
                        HStack {
                            TextField("21", text: $prescription.vitals.age)
                                .keyboardType(.numberPad)
                                .font(.title)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Gender")
                            .font(.subheadline)
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
            }
            
            Section("Chief Complaints") {
                SymptomsList(symptoms: $prescription.symptoms)
            }
            
            Section("Suggested Medicines") {
                MedicinesList(medicines: $prescription.medicines)
            }
            
            Button("Delete Patient", systemImage: "trash", role: .destructive) {
                
            }
            .foregroundColor(.red)
        }
        .listStyle(.grouped)
        .navigationTitle("Patient Details")
        .toolbar {
            NavigationLink {
                GeneratePrescriptionView(prescription: prescription)
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .fontWeight(.medium)
                }
            }

        }
    }
}

#Preview {
    PrescriptionBuilderView(prescription: Prescription(
            patientName: "Jaagrav Seal",
            doctorName: "Sushan Mukhopadhyay",
            speciality: "Cardiologist",
            vitals: Vitals(heartBpm: "92", bloodPressure: ["120", "80"], age: "21", tempInF: "98", gender: .male),
            symptoms: [
                Symptom(description: "Common cold", notes: "With runny nose and cough"),
                Symptom(description: "Mild fever", notes: ""),
            ],
            medicines: [
                Medicine(schedule: MedicineSchedule(hour: -1, minutes: -1, days: [], isSOS: true), name: "Paracetamol", quantity: "650mg", notes: "SOS"),
                Medicine(schedule: MedicineSchedule(hour: 22, minutes: 30, days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], isSOS: false), name: "Cough Syrup", quantity: "2mL", notes: "Every night before sleeping"),
            ]
        )
    )
}
