//
//  IntroView2.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 30/12/24.
//

import SwiftUI

struct IntroView2: View {
    @ObservedObject var appState = AppState.shared
    
    @State var userType: UserType = .doctor
    @State var firstName: String = "John"
    @State var lastName: String = "Doe"
    @State var phoneNumber: String = "1234567890"
    @State var speciality: String = "Cardiologist"
    @State var gender: Gender = .male
    @State var age: String = "25"
    @State private var currentPage = 0
    
    func submit() {
        appState.appLevel = .authorised
        appState.user = User(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, userType: userType, speciality: speciality, age: age, gender: gender)
    }
    
    var body: some View {
        ZStack {
            GradientAnimation()
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Welcome to")
                            .opacity(0.5)

                        Text("PrescribeIT")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .frame(maxWidth: 500)
                
                OnboardingView()
                    .frame(maxWidth: 500)
                
                Button {
                    userType = .patient
                    submit()
                } label: {
                    HStack {
                        Text("Continue as a Patient")
                    }
                    .foregroundColor(.accentColor)
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(14)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: 500)
                .padding(.horizontal, 24)
                
                Button {
                    userType = .doctor
                    submit()
                } label: {
                    HStack {
                        Text("Continue as a Doctor")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(14)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: 500)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    IntroView2()
}
