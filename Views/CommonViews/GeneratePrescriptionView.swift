//
//  GeneratePrescriptionView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 26/12/24.
//

import SwiftUI
import PDF_Generator

struct GeneratePrescriptionView: View {
    @StateObject var appState = AppState.shared
    @StateObject var prescription: Prescription
    @State var useDarkMode = false
    
    var body: some View {
        List {
            Section("Preview") {
                PrescriptionPreview(prescription: prescription)
            }
//            .foregroundColor(.primary)
//            .background(Color(.secondarySystemBackground))
//            .environment(\.colorScheme, useDarkMode ? .dark : .light)
            
            Section("Save") {
//                Toggle("Show dark mode", isOn: $useDarkMode)
//                    .toggleStyle(.switch)
//                    .font(.callout)
                PDFGeneratingButton {
                    PrescriptionPreview(prescription: prescription, withPadding: true)
//                        .environment(\.colorScheme, useDarkMode ? .dark : .light)
                } label: {
                    Label("Save PDF to files", systemImage: "square.and.arrow.down")
                }
            }
            
            if appState.user?.userType == .doctor {
                Section("Share") {
                    NearbyPatientsList(prescription: prescription)
                }
            }
            else if appState.user?.userType == .patient {
                Section("Schedule") {
                    Button("Set Reminders", systemImage: "calendar.badge.clock", action: {
                        
                    })
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle(appState.user?.userType == .patient ? "Your Prescription" : "Share Prescription")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    var prescription = Prescription(
        patientName: "Jaagrav Seal",
        doctorName: "Sushan Mukhopadhyay",
        speciality: "Cardiologist",
        vitals: Vitals(heartBpm: "92", bloodPressure: ["120", "80"], age: "21", tempInF: "98", gender: .male),
        symptoms: [
            Symptom(description: "Common cold", notes: "With runny nose and cough"),
            Symptom(description: "Mild fever", notes: ""),
        ],
        medicines: [
            Medicine(schedule: MedicineSchedule(hour: 10, minutes: 0, days: ["Monday"], isSOS: true), name: "Paracetamol", quantity: "650mg", notes: "Take in case fever crosses 102 fahrenheitz"),
            Medicine(schedule: MedicineSchedule(hour: 22, minutes: 30, days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], isSOS: false), name: "Cough Syrup", quantity: "2ml", notes: "Every night before sleeping"),
        ]
    )

    GeneratePrescriptionView(prescription: prescription)
}
