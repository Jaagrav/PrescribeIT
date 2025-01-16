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
        }
    }
}

#Preview {
    DoctorHomeView()
}
