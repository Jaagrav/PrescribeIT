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
    @Binding var path: NavigationPath
    @StateObject var sharedPrescriptions = Prescriptions.shared
    
    @State var showDeletePrescription: Bool = false
    @State var activePrescription: Prescription? = nil
    
    var receivedPrescription: Bool?
    var notificationManager = NotificationManager.shared
    
    func setReminders() -> Void {
        notificationManager.requestPermission {
            notificationManager.unscheduleAllNotifications()
            notificationManager.scheduleNotification(prescription: prescription)
            
            activePrescription = notificationManager.getActivePrescriptionSynchronously(
                allPrescriptions: sharedPrescriptions.prescriptions
            )
            
            notificationManager.sendNotification(
                title: "Medicine reminders set successfully!",
                body: "Prescription by Dr \(prescription.doctor.fullName) is now active and you'll be notified when it's time to take medicines."
            )
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if UIDevice.current.userInterfaceIdiom == .phone && appState.user?.userType == .patient && path.count != 0 {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.fixed(180)),
                    GridItem(.flexible())
                ], spacing: 0) {
                    HStack {
                        Button("Back", systemImage: "chevron.backward") {
                            path.removeLast()
                        }
                        .fontWeight(.medium)
                        Spacer()
                    }
                    
                    Text(appState.user?.userType == .patient ? "Your Prescription" : "Share Prescription")
                        .fontWeight(.semibold)
                }
                .padding(.top, 4)
                .padding(.bottom, 12)
                .padding(.horizontal, 24)
                Divider()
            }
            List {
                Section("Preview") {
                    VStack(alignment: .center) {
                        PrescriptionPreview(prescription: prescription)
                    }
                    .padding(4)
                    .border(Color(.secondaryLabel))
                    .padding(.horizontal, 2)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                }
                
                Section("Save") {
                    PDFGeneratingButton {
                        PrescriptionPreview(prescription: prescription, withPadding: true)
                    } label: {
                        Label("Save PDF to files", systemImage: "square.and.arrow.down")
                            .padding(.vertical, 12)
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
                            .padding(.vertical, 12)
                        }
                        else {
                            Button("Set Reminders", systemImage: "calendar.badge.clock", action: {
                                setReminders()
                            })
                            .padding(.vertical, 12)
                        }
                    }
                    
                    if receivedPrescription != true {
                        Button("Delete Prescription", systemImage: "trash", role: .destructive) {
                            showDeletePrescription = true
                        }
                        .foregroundColor(.red)
                        .padding(.vertical, 12)
                    }
                }
            }
            .onAppear {
                activePrescription = notificationManager.getActivePrescriptionSynchronously(allPrescriptions: sharedPrescriptions.prescriptions)
            }
            .listStyle(.insetGrouped)
            .navigationTitle(appState.user?.userType == .patient ? "Your Prescription" : "Share Prescription")
            .navigationBarTitleDisplayMode(.large)
            .alert("You are about to delete Dr \(prescription.doctor.fullName)'s prescription", isPresented: $showDeletePrescription) {
                Button("Cancel", role: .cancel) {
                    showDeletePrescription = false
                }
                Button("Delete", role: .destructive) {
                    Prescriptions.shared.deletePrescription(prescription: prescription)
                    notificationManager.unscheduleAllNotifications()
                    path.removeLast()
                }
            }
        }
    }
}

#Preview {
    var prescription = Prescription(
        patientName: "Jaagrav Seal",
        doctor: Doctor(fullName: "Sushan Mukhopadhyay", phoneNumber: "0123456789", speciality: "Cardiologist"),
        vitals: Vitals(heartBpm: "92", bloodPressure: ["120", "80"], age: "21", tempInF: "98", gender: .male),
        symptoms: [
            Symptom(description: "Common cold", notes: "With runny nose and cough"),
            Symptom(description: "Mild fever", notes: ""),
        ],
        medicines: [
                Medicine(schedule: MedicineSchedule(daypart: ["Afternoon", "Night"], days: ["Monday"], isSOS: true), name: "Paracetamol", quantity: "650mg", notes: "Take in case fever crosses 102 fahrenheitz"),
                Medicine(schedule: MedicineSchedule(daypart: ["Night"], days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], isSOS: false), name: "Cough Syrup", quantity: "2ml", notes: "Every night before sleeping"),
        ],
        isSample: true
    )
    @State var path = NavigationPath()

    GeneratePrescriptionView(prescription: prescription, path: $path)
}
