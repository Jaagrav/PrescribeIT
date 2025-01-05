//
//  GeneratePrescriptionView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 26/12/24.
//

import SwiftUI
import PDF_Generator

struct GeneratePrescriptionView: View {
    var appState = AppState.shared
    
    @StateObject var prescription: Prescription
    @StateObject var sharedPrescriptions = Prescriptions.shared
    
    @State var showDeletePrescription: Bool = false
    @State var activePrescription: Prescription? = nil
    
    var notificationManager = NotificationManager.shared
    
    var body: some View {
        List {
            Section("Preview") {
                PrescriptionPreview(prescription: prescription)
            }
            
            Section("Save") {
                PDFGeneratingButton {
                    PrescriptionPreview(prescription: prescription, withPadding: true)
                } label: {
                    Label("Save PDF to files", systemImage: "square.and.arrow.down")
                }
            }
            
            if appState.user?.userType == .doctor {
                NearbyPatientsList(prescription: prescription)
            }
            else if appState.user?.userType == .patient {
                Section("Schedule") {
                    if activePrescription?.uid == prescription.uid {
                        Button("Pause all Reminders", systemImage: "pause.circle", action: {
                            notificationManager.unscheduleAllNotifications()
                            
                            activePrescription = nil
                        })
                    }
                    else {
                        Button("Set Reminders", systemImage: "calendar.badge.clock", action: {
                            notificationManager.unscheduleAllNotifications()
                            notificationManager.scheduleNotification(prescription: prescription)
                            
                            activePrescription = notificationManager.getActivePrescriptionSynchronously(allPrescriptions: sharedPrescriptions.prescriptions)
                            
                            notificationManager.sendNotification(title: "Medicine reminders set successfully!", body: "Prescription by Dr \(prescription.doctorName) is now active and you'll be notified when it's time to take medicines.")
                        })
                    }
                }
                
                Button("Delete Prescription", systemImage: "trash", role: .destructive) {
                    showDeletePrescription = true
                }
                .foregroundColor(.red)
            }
        }
        .onAppear {
            activePrescription = notificationManager.getActivePrescriptionSynchronously(allPrescriptions: sharedPrescriptions.prescriptions)
        }
        .listStyle(.grouped)
        .navigationTitle(appState.user?.userType == .patient ? "Your Prescription" : "Share Prescription")
        .navigationBarTitleDisplayMode(.large)
        .alert("You are about to delete Dr \(prescription.doctorName)'s prescription", isPresented: $showDeletePrescription) {
            Button("Cancel", role: .cancel) {
                showDeletePrescription = false
            }
            Button("Delete", role: .destructive) {
                Prescriptions.shared.deletePrescription(prescription: prescription)
                notificationManager.unscheduleAllNotifications()
            }
        }
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
                Medicine(schedule: MedicineSchedule(daypart: ["Afternoon", "Night"], days: ["Monday"], isSOS: true), name: "Paracetamol", quantity: "650mg", notes: "Take in case fever crosses 102 fahrenheitz"),
                Medicine(schedule: MedicineSchedule(daypart: ["Night"], days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], isSOS: false), name: "Cough Syrup", quantity: "2ml", notes: "Every night before sleeping"),
        ]
    )

    GeneratePrescriptionView(prescription: prescription)
}
