//
//  PatientHomeView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 30/12/24.
//

import SwiftUI

enum SplitViews {
case savedPrescriptions, getPrescription
}

struct PatientHomeView: View {
    @State var searchText = ""
    @StateObject var appState = AppState.shared
    @State var splitViews: SplitViews = .savedPrescriptions
    
    func getGreetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        var greeting = ""

        if hour < 12 {
            greeting = "Good Morning"
        }
        else if hour > 12 && hour < 16 {
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
                    
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField(
                                "Search prescriptions",
                                text: $searchText
                            )
                        }
                        .padding(.all, 12)
                        .background(.background.opacity(0.5))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.background, lineWidth: 2)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    
                    Picker("Split Views", selection: $splitViews) {
                        Text("Saved Prescriptions").tag(SplitViews.savedPrescriptions)
                        Text("New Prescriptions").tag(SplitViews.getPrescription)
                    }
                    .pickerStyle(.segmented)
                    .padding(24)
                    
                    switch splitViews {
                    case .savedPrescriptions:
                        PrescriptionsList()
                            .transition(.opacity)
                    case .getPrescription:
                        FetchPrescriptions()
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut, value: splitViews)
            }
        }
    }
}

#Preview {
    PatientHomeView()
}
