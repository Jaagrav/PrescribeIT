//
//  PatientHomeView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 30/12/24.
//

import SwiftUI
import AVFoundation
import UIKit

struct PatientSidebar: View {
    @State var currentPage = 0
    @ObservedObject var appState = AppState.shared
    @Binding var path: NavigationPath
    var namespace: Namespace.ID
    
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
        GradientAnimation()
        
        VStack(spacing: 0) {
            Text(getGreetingMessage())
                .opacity(0.6)
                .padding(.top, 34)
            
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
            .padding(.top, 26)
            .padding(.horizontal, 24)
            
            TabView(selection: $currentPage) {
                PrescriptionsList(path: $path, namespace: namespace)
                    .tag(0)
                
                ActivePrescription(path: $path)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
        }
        
        FloatingActionButtons(showNewPrescriptionButton: false, path: $path)
    }
}

struct PatientHomeView: View {
    @StateObject var sharedPrescriptions = Prescriptions.shared
    @ObservedObject var appState = AppState.shared
    @StateObject var mcManager = MultipeerManager(user: AppState.shared.user!, userType: "patient")
    
    var notificationManager = NotificationManager.shared
    
    @State var newPrescriptionReceived: Bool = false
    
    @State var path = NavigationPath()
    
    @Namespace var namespace
    
    var body: some View {
        RootNavView {
            ZStack {
                PatientSidebar(path: $path, namespace: namespace)
            }
            .background(Color(UIColor.systemBackground))
        } detail: {
            NavigationStack(path: $path) {
                ZStack {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        PatientSidebar(path: $path, namespace: namespace)
                    }
                }
                .navigationDestination(for: String.self) { value in
                    ForEach(sharedPrescriptions.prescriptions) { prescription in
                        if prescription.uid.uuidString == value {
                            if #available(iOS 18, *) {
                                VStack {
                                    GeneratePrescriptionView(prescription: prescription, path: $path)
                                        .toolbar(.hidden)
                                }
                                .navigationTransition(.zoom(sourceID: "prescription-\(prescription.uid)", in: namespace))
                            } else {
                                GeneratePrescriptionView(prescription: prescription, path: $path)
                                    .toolbar(.hidden)
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: mcManager.receivedPrescription, perform: { newValue in
            if newValue != nil {
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
                    GeneratePrescriptionView(prescription: mcManager.receivedPrescription!, path: $path, receivedPrescription: true)
                }
            }
        }
        .background(Color(.systemBackground))
        .onChange(of: appState.user) { newValue in
            mcManager.reset(user: appState.user!, userType: "patient")
        }
        .onAppear {
            mcManager.start()
        }
        .onDisappear {
            mcManager.stop()
        }
    }
}

#Preview {
    PatientHomeView()
}
