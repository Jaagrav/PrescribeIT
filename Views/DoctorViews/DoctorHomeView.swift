//
//  DoctorHomeView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 22/12/24.
//

import SwiftUI

struct DoctorSidebar: View {
    @ObservedObject var sharedUser = AppState.shared
    @State var searchText: String = ""
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
                    .submitLabel(.done)
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
            
            PatientsList(searchText: searchText, path: $path, namespace: namespace)
        }
        
        FloatingActionButtons(path: $path)
    }
}

struct DoctorHomeView: View {
    @State var path = NavigationPath()
    @StateObject var sharedPrescriptions = Prescriptions.shared
    
    @Namespace private var namespace
    
    var body: some View {
        RootNavView {
            ZStack {
                DoctorSidebar(path: $path, namespace: namespace)
            }
            .background(Color(UIColor.systemBackground))
        } detail: {
            NavigationStack(path: $path) {
                ZStack {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        DoctorSidebar(path: $path, namespace: namespace)
                    }
                }
                .navigationDestination(for: String.self) { value in
                    ForEach($sharedPrescriptions.prescriptions) { $prescription in
                        if prescription.uid.uuidString == value {
                            if #available(iOS 18, *) {
                                PrescriptionBuilderView(prescription: $prescription, path: $path)
                                    .navigationTransition(.zoom(sourceID: "prescription-\(prescription.uid)", in: namespace))
                            } else {
                                PrescriptionBuilderView(prescription: $prescription, path: $path)
                            }
                        }
                    }
                    .navigationBarBackButtonHidden()
                }
                .background(Color(.systemBackground))
            }
        }     
    }
}

#Preview {
    DoctorHomeView()
}
