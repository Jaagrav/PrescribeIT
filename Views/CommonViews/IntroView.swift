//
//  IntroView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 30/12/24.
//

import SwiftUI

struct IntroView: View {
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
        switch userType {
        case .doctor:
            appState.user = User(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, userType: .doctor, speciality: speciality)
            
        case .patient:
            appState.user = User(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, userType: .patient, age: age, gender: gender)
        }
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
                
                TabView(selection: $currentPage) {
                    OnboardingView()
                        .frame(maxWidth: 500)
                        .tag(0)
                    ScrollView {
                        VStack(spacing: 24) {
                            Picker("User Type", selection: $userType) {
                                Text("Doctor").tag(UserType.doctor)
                                Text("Patient").tag(UserType.patient)
                            }
                            .pickerStyle(.segmented)
                            
                            VStack(alignment: .leading) {
                                Text("First Name")
                                    .font(.footnote)
                                TextField("e.g. Jaagrav", text: $firstName)
                                    .font(.title)
                                    .submitLabel(.done)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Last Name")
                                    .font(.footnote)
                                TextField("e.g. Seal", text: $lastName)
                                    .font(.title)
                                    .submitLabel(.done)
                            }
                            
                            switch userType {
                            case .doctor:
                                VStack(alignment: .leading) {
                                    Text("Phone Number")
                                        .font(.footnote)
                                    TextField("e.g. 123-456-789", text: $phoneNumber)
                                        .keyboardType(.numberPad)
                                        .font(.title)
                                        .submitLabel(.done)
                                }
                                .transition(.opacity)
                                VStack(alignment: .leading) {
                                    Text("Speciality")
                                        .font(.footnote)
                                    TextField("e.g. Cardiologist, Dentist", text: $speciality)
                                        .font(.title)
                                        .submitLabel(.done)
                                }
                                .transition(.opacity)
                            case .patient:
                                VStack(alignment: .leading) {
                                    Text("Age")
                                        .font(.footnote)
                                    TextField("e.g. 21, 47", text: $age)
                                        .keyboardType(.numberPad)
                                        .font(.title)
                                        .submitLabel(.done)
                                }
                                .transition(.opacity)
                                VStack(alignment: .leading) {
                                    Text("Gender")
                                        .font(.footnote)
                                    Picker("Gender", selection: $gender) {
                                        Text("Male")
                                            .tag(Gender.male)
                                        Text("Female")
                                            .tag(Gender.female)
                                        Text("Non-binary")
                                            .tag(Gender.nonbinary)
                                        Text("Other")
                                            .tag(Gender.other)
                                    }
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.tertiary, lineWidth: 1)
                                    }
                                }
                                .transition(.opacity)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .animation(.easeInOut, value: userType)
                    }
                    .frame(maxWidth: 500)
                    .tag(1)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle())
                .animation(.easeInOut, value: currentPage)
                
                Button {
                    if currentPage == 0 {
                        currentPage = 1
                    } else {
                        submit()
                    }
                } label: {
                    HStack {
                        Text(currentPage == 0 ? "Let's get started" : "Sign in as a \(userType.rawValue)")
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
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .frame(maxWidth: 500)
            }
        }
    }
}

#Preview {
    IntroView()
}
