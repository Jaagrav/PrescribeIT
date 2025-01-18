//
//  DoctorHomeView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 22/12/24.
//

import SwiftUI

struct DoctorHomeView: View {
    @State var searchText: String = ""
    
    @ObservedObject var sharedUser = AppState.shared
    
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
                    
                    Text("Dr \(sharedUser.user!.firstName) \(sharedUser.user!.lastName)")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField(
                                "Search patient",
                                text: $searchText
                            )
                        }
                        .padding(.all, 12)
                        .background(.background.opacity(0.6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.background, lineWidth: 2)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    
                    PatientsList(searchText: searchText)
                }
                
                FloatingActionButtons()
            }
            .background(Color(.systemBackground))
            
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
    DoctorHomeView()
}
