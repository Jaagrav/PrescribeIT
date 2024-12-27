//
//  DoctorHomeView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 22/12/24.
//

import SwiftUI

struct DoctorHomeView: View {
    @State var searchText: String = ""
    
    @ObservedObject var sharedUser = SharedUser()
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientAnimation()
                
                ScrollView {
                    Text("Good Afternoon")
                        .opacity(0.6)
                        .padding(.top, 32)
                    
                    Text("Dr \(sharedUser.user.firstName) \(sharedUser.user.lastName)")
                        .font(.largeTitle)
                        .bold()
                    
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
                    
                    PrescriptionsList()
                }
                
                NewPrescriptionButton()
            }
        }
    }
}

#Preview {
    DoctorHomeView()
}
