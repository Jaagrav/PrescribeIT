//
//  FetchPrescriptions.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 01/01/25.
//

import SwiftUI

struct FetchPrescriptions: View {
    @StateObject private var mcManager = MultipeerManager(user: AppState.shared.user!, userType: "patient")
    
    var body: some View {
        VStack {
            if mcManager.receivedPrescription != nil {
                PrescriptionListItem(prescription: mcManager.receivedPrescription!)
            }
            else {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("Waiting for prescriptions...")
                    Spacer()
                }
            }
        }
        .onAppear {
            mcManager.start()
        }
        .onDisappear {
            mcManager.stop()
        }
    }
}

#Preview {
    FetchPrescriptions()
}
