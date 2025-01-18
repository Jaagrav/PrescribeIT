//
//  PatientHomeView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 30/12/24.
//

import SwiftUI
import AVFoundation
import UIKit

struct PatientHomeView: View {
    var sharedPrescriptions = Prescriptions.shared
    @State var searchText = ""
    @ObservedObject var appState = AppState.shared
    @State var currentPage = 0
    @StateObject var mcManager = MultipeerManager(user: AppState.shared.user!, userType: "patient")
    
    var notificationManager = NotificationManager.shared
    
    @State var newPrescriptionReceived: Bool = false
    
    func getGreetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        var greeting = ""

        if hour < 12 {
            greeting = "Good Morning"
        }
        else if hour >= 12 && hour <= 16 {
            greeting = "Good Afternoon"
        }
        else if hour > 16 && hour <= 23 {
            greeting = "Good Evening"
        }
        
        return greeting
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientAnimation()
                VStack {
                    Text(getGreetingMessage())
                        .opacity(0.6)
                        .padding(.top, 32)
                    
                    Text("\(appState.user!.firstName) \(appState.user!.lastName)")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    Picker("Split Views", selection: $currentPage) {
                        Text("Saved Prescriptions")
                            .tag(0)
                            .padding()
                        Text("My Medicines")
                            .tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(24)
                    .padding(.bottom, 4)
                    
                    TabView(selection: $currentPage) {
                        PrescriptionsList()
                            .tag(0)
                        
                        ActivePrescription()
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle())
                    .animation(.easeInOut, value: currentPage)
                }
                .onChange(of: mcManager.receivedPrescription, perform: { newValue in
                    if mcManager.receivedPrescription != nil {
                        newPrescriptionReceived = true
                        AudioServicesPlaySystemSound(1007)
                        
                        let feedbackGenerator = UINotificationFeedbackGenerator()
                        feedbackGenerator.notificationOccurred(.success)
                        
                        sharedPrescriptions.createPrescription(prescription: mcManager.receivedPrescription!)
                    }
                })
                .sheet(isPresented: $newPrescriptionReceived, onDismiss: {
                    mcManager.receivedPrescription = nil
                }) {
                    if mcManager.receivedPrescription != nil {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Received Prescription")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                                Button {
                                    newPrescriptionReceived = false
                                } label: {
                                    Text("Save")
                                }
                            }
                            .padding(16)
                            .padding(.bottom, -16)
                            Text("Dr \(mcManager.receivedPrescription!.doctor.fullName) has just shared a prescription with you!")
                                .padding(.horizontal, 16)
                                .font(.caption)
                                .opacity(0.6)
                            GeneratePrescriptionView(prescription: mcManager.receivedPrescription!)
                        }
                    }
                }
                
                FloatingActionButtons(showNewPrescriptionButton: false)
            }
            .background(Color(.systemBackground))
            .onAppear {
                mcManager.start()
                notificationManager.requestPermission()
            }
            .onDisappear {
                mcManager.stop()
            }
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Welcome to")
                            .opacity(0.5)
                        
                        Text("PrescribeIT")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                        
                        Text("PrescribeIT is an app for both doctors and patients.")
                        
                        FeatureBlock(icon: "heart.text.square", title: "Create Prescriptions", description: "Doctors can quickly create, share, and manage prescriptions with an intuitive interface.")
                        
                        FeatureBlock(icon: "calendar.badge.clock", title: "Set Reminders at one click", description: "Patients can easily set reminders for all their medications at one click on receiving prescriptions from their doctors.")
                        
                        FeatureBlock(icon: "person.line.dotted.person.fill", title: "Share with patient offline", description: "Doctors can share prescriptions with their patients wirelessly without any internet connection or WiFi.")
                        
                        FeatureBlock(icon: "accessibility", title: "Clear and Readable Prescriptions", description: "Say goodbye to confusion with organized, easy-to-read digital prescriptions that can be saved as PDFs effortlessly.")
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .frame(maxWidth: 500)
            }
        }
    }
}

#Preview {
    PatientHomeView()
}
