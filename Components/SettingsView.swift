//
//  SettingsView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 24/02/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var appState = AppState.shared
    @Binding var showDrawer: Bool
    var notificationManager = NotificationManager.shared
    @State var showLogoutModal = false
    
    @State var userType: UserType = .doctor
    @State var firstName: String = "John"
    @State var lastName: String = "Doe"
    @State var phoneNumber: String = "1234567890"
    @State var speciality: String = "Cardiologist"
    @State var gender: Gender = .male
    @State var age: String = "25"
    
    func submit() {
        showDrawer = false
        appState.appLevel = .authorised
        notificationManager.unscheduleAllNotifications()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            appState.user = User(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, userType: userType, speciality: speciality, age: age)
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 24)
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("Are you a doctor or a patient?")
                            .font(.footnote)
                        Picker("User Type", selection: $userType) {
                            Text("Doctor").tag(UserType.doctor)
                            Text("Patient").tag(UserType.patient)
                        }
                        .pickerStyle(.segmented)
                    }
                    
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
                }
                .padding(.horizontal, 24)
                .animation(.easeInOut, value: userType)
            }
            .onAppear {
                guard let user = appState.user else { return }
                
                userType = user.userType
                firstName = user.firstName
                lastName = user.lastName
                phoneNumber = user.phoneNumber
                speciality = user.speciality
                gender = user.gender
                age = user.age
            }
            
            Spacer()
            
            Button {
                showLogoutModal = true
            } label: {
                HStack {
                    Text("Reset PrescribeIT")
                }
                .foregroundColor(.red)
            }
            .alert("You are about to reset PrescribeIT", isPresented: $showLogoutModal) {
                Button("Reset", role: .destructive) {
                    appState.appLevel = .onboarding
                    notificationManager.unscheduleAllNotifications()
                }
            }

            Button {
                submit()
            } label: {
                HStack {
                    Text("Save \(userType.rawValue) details")
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
            .padding(.top, 8)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .frame(maxWidth: 500)
            .animation(.easeInOut, value: userType)
        }
    }
}

#Preview {
    @State var showSettings: Bool = false
    SettingsView(showDrawer: $showSettings)
}
