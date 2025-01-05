//
//  PatientHomeView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 30/12/24.
//

import SwiftUI
import AVFoundation
import UIKit

enum SplitViews {
case savedPrescriptions, activePrescription
}

struct PatientHomeView: View {
    var sharedPrescriptions = Prescriptions.shared
    @State var searchText = ""
    @ObservedObject var appState = AppState.shared
    @State var splitViews: SplitViews = .savedPrescriptions
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
                ScrollView {
                    Text(getGreetingMessage())
                        .opacity(0.6)
                        .padding(.top, 32)
                    
                    Text("\(appState.user!.firstName) \(appState.user!.lastName)")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    
//                    HStack {
//                        HStack {
//                            Image(systemName: "magnifyingglass")
//                            TextField(
//                                "Search prescriptions",
//                                text: $searchText
//                            )
//                        }
//                        .padding(.all, 12)
//                        .background(.background.opacity(0.5))
//                        .cornerRadius(12)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(.background, lineWidth: 2)
//                        )
//                    }
//                    .padding(.horizontal, 24)
//                    .padding(.top, 24)
//                    .padding(.bottom, -12)
                    
                    Picker("Split Views", selection: $splitViews) {
                        Text("Saved Prescriptions")
                            .tag(SplitViews.savedPrescriptions)
                            .padding()
                        Text("My Medicines")
                            .tag(SplitViews.activePrescription)
                    }
                    .pickerStyle(.segmented)
                    .padding(24)
                    .padding(.bottom, 4)
                    
                    switch splitViews {
                    case .savedPrescriptions:
                        PrescriptionsList()
                            .transition(.opacity)
                    case .activePrescription:
                        ActivePrescription()
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut, value: splitViews)
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
                            Text("Dr \(mcManager.receivedPrescription!.doctorName) has just shared a prescription with you!")
                                .padding(.horizontal, 16)
                                .font(.caption)
                                .opacity(0.6)
                            GeneratePrescriptionView(prescription: mcManager.receivedPrescription!)
                        }
                    }
                }
                
                FloatingActionButtons(showNewPrescriptionButton: false)
            }
            .onAppear {
                mcManager.start()
                notificationManager.requestPermission()
            }
            .onDisappear {
                mcManager.stop()
            }
        }
    }
}

#Preview {
    PatientHomeView()
}
