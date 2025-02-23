//
//  PrescriptionsList.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 30/12/24.
//

import SwiftUI

struct PrescriptionsList: View {
    @ObservedObject var sharedPrescriptions = Prescriptions.shared
    @Binding var path: NavigationPath
    var namespace: Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                if sharedPrescriptions.prescriptions.isEmpty {
                    VStack {
                        VStack {
                            Image("NoPrescriptions")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200)
                                .padding(.top, 0)
                                .padding(.bottom, 12)
                            Text("You are now discoverable")
                                .font(.title3)
                            Text("Your saved prescriptions will appear here when your doctor shares it with you")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 300)
                                .padding(.top, 4)
                        }
                        .opacity(0.6)
                    }
                    .frame(height: UIScreen.main.bounds.height / 2)
                }
                ForEach($sharedPrescriptions.prescriptions) { $prescription in
                    PrescriptionListItem(prescription: $prescription, path: $path, namespace: namespace)
                }
                NetworkIssuesHelper()
            }
            .padding(.top, 24)
        }
    }
}
