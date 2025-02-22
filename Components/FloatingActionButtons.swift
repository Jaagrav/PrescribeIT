//
//  FloatingActionButtons.swift
//  PrescribeIt
//
//  Created by Jaagrav Seal on 23/12/24.
//

import SwiftUI

struct FloatingActionButtons: View {
    @State var showNewPrescriptionDrawer = false
    @State var showCallListDrawer = false
    var appState = AppState.shared
    var notificationManager = NotificationManager.shared
    @State var showLogoutConfirmation: Bool = false
    var showNewPrescriptionButton: Bool = true
    @Binding var path: NavigationPath
    
    func openDrawer () {
        if showNewPrescriptionButton {
            showNewPrescriptionDrawer = true
        } else {
            showCallListDrawer = true
        }
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
                        .frame(width: 45, height: 45)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(120)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: openDrawer) {
                        Image(systemName: showNewPrescriptionButton ? "plus" : "phone.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.accentColor)
                            .cornerRadius(100)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.trailing, UIDevice.current.userInterfaceIdiom == .phone ? 24 : 12)
            .padding(.bottom, UIDevice.current.userInterfaceIdiom == .phone ? 0 : 24)
        }
        .sheet(isPresented: $showNewPrescriptionDrawer) {
            NewPrescriptionView(showDrawer: $showNewPrescriptionDrawer, path: $path)
        }
        .sheet(isPresented: $showCallListDrawer) {
            CallListView(showDrawer: $showCallListDrawer)
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
