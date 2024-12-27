//
//  GeneratePrescriptionView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 26/12/24.
//

import SwiftUI
import PDF_Generator

struct GeneratePrescriptionView: View {
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
            
            Section("Share") {
//                Toggle("Show dark mode", isOn: $useDarkMode)
//                    .toggleStyle(.switch)
//                    .font(.callout)
                PDFGeneratingButton {
                    PrescriptionPreview(prescription: prescription, withPadding: true)
//                        .environment(\.colorScheme, useDarkMode ? .dark : .light)
                } label: {
                    Label("Save to files", systemImage: "square.and.arrow.down")
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Share Prescription")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    var prescription = Prescription(
        fullName: "Jaagrav Seal",
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
