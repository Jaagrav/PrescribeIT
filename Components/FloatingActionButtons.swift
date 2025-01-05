//
//  FloatingActionButtons.swift
//  PrescribeIt
//
//  Created by Jaagrav Seal on 23/12/24.
//

import SwiftUI

struct FloatingActionButtons: View {
    @State var showDrawer = false
    var appState = AppState.shared
    var notificationManager = NotificationManager.shared
    @State var showLogoutConfirmation: Bool = false
    var showNewPrescriptionButton: Bool = true
    
    func createNewPrescription () {
        showDrawer = true
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 12) {
                    Button {
                        showLogoutConfirmation = true
                    } label: {
                        VStack {
                            Image(systemName: "iphone.and.arrow.forward.outward")
                                .font(.title3)
                        }
                        .padding(16)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(120)
                    }
                    
                    if showNewPrescriptionButton {
                        Button(action: createNewPrescription) {
                            Image(systemName: "plus")
                                .font(.title)
                                .padding(18)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .cornerRadius(100)
                        }
                    }
                }
            }
            .padding(.trailing, 24)
        }
        .sheet(isPresented: $showDrawer) {
            NewPrescriptionView(showDrawer: $showDrawer)
        }
        .alert("You are about to log out. Are you sure?", isPresented: $showLogoutConfirmation) {
            Button("Cancel", role: .cancel) {
                showLogoutConfirmation = false
            }
            Button("Log out", role: .destructive) {
                appState.appLevel = .onboarding
                notificationManager.unscheduleAllNotifications()
            }
        }
    }
}

#Preview {
    FloatingActionButtons()
}
