//
//  NewPrescriptionView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 24/12/24.
//

import SwiftUI

struct NewPrescriptionView: View {
    var appState = AppState.shared
    var sharedPrescriptions = Prescriptions.shared
    
    @Binding var showDrawer: Bool
    
    @State var patientName = ""
    @State var heartRate: String = ""
    @State var bloodPressure: [String] = ["", ""]
    @State var age: String = ""
    @State var gender: Gender = .male
    
    func createNewPrescription() {
        let prescription = Prescription(patientName: patientName, doctorName: "\(appState.user?.firstName ?? "") \(appState.user?.lastName ?? "")", speciality: appState.user?.speciality ?? "", vitals: Vitals(heartBpm: heartRate, bloodPressure: bloodPressure, age: age, tempInF: "", gender: gender), symptoms: [], medicines: [])
        
        sharedPrescriptions.createPrescription(prescription: prescription)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("New Patient")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    showDrawer = false
                } label: {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
            }
            .padding(20)
            .padding(.bottom, -20)
            
            List {
                Section("Patient Name") {
                    TextField("e.g. Jaagrav Seal", text: $patientName)
                        .font(.title)
                }
                
                Section("General Information") {
                    HStack(spacing: 24) {
                        VStack(alignment: .leading) {
                            Text("Heart Rate (bpm)")
                                .font(.subheadline)
                            HStack {
                                TextField("90", text: $heartRate)
                                    .keyboardType(.numberPad)
                                    .font(.title)
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Blood Pressure (mmHg)")
                                .font(.subheadline)
                            HStack {
                                TextField("120", text: $bloodPressure[0])
                                    .keyboardType(.numberPad)
                                    .font(.title)
                                Text("/")
                                    .font(.title)
                                TextField("80", text: $bloodPressure[1])
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
                                TextField("21", text: $age)
                                    .keyboardType(.numberPad)
                                    .font(.title)
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Gender")
                                .font(.subheadline)
                            HStack {
                                Picker("Gender", selection: $gender) {
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
            }
            .listStyle(.grouped)
            
            Button {
                createNewPrescription()
                showDrawer = false
            } label: {
                VStack {
                    Text("Create")
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding(12)
                .background(Color.accentColor)
                .cornerRadius(12)
                .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    @State var showDrawer = false
    NewPrescriptionView(showDrawer: $showDrawer)
}
