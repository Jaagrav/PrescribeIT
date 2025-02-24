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
    @State var showSettings: Bool = false
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
                        showSettings = true
                    } label: {
                        VStack {
                            Image(systemName: "gear")
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
        .sheet(isPresented: $showSettings) {
            SettingsView(showDrawer: $showSettings)
        }
    }
}
