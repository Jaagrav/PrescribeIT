//
//  NearbyPatientsList.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 29/12/24.
//

import SwiftUI
import MultipeerConnectivity

struct NearbyPatientsList: View {
    @StateObject var mcManager = MultipeerManager(user: AppState.shared.user!, userType: "doctor")
    @StateObject var prescription: Prescription
    
    @State private var hasAppeared = false
    
    @State var showPrescriptionSentSuccess: Bool = false
    
    var body: some View {
        Section("Share with Nearby Patients") {
            if mcManager.discoveredPeers.isEmpty {
                HStack {
                    Spacer()
                    Image("MultipeerConnectivitySharing")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                        .padding(.top, 0)
                        .padding(.bottom, 12)
                    Spacer()
                }
            } else {
                ForEach(mcManager.discoveredPeers, id: \.self) { peer in
                    Button {
                        let feedbackGenerator = UINotificationFeedbackGenerator()
                        mcManager.send(peerId: peer.peerID, prescription: prescription)
                        showPrescriptionSentSuccess = true
                        feedbackGenerator.notificationOccurred(.success)
                    } label: {
                        HStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(UIColor.secondarySystemBackground), Color.gray]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 50, height: 50)
                                .overlay {
                                    Text(peer.name.prefix(2).uppercased())
                                        .foregroundColor(.white)
                                        .font(.title3)
                                }
                            VStack(alignment: .leading) {
                                Text(peer.name)
                                Text("\(peer.age) years old • \(peer.gender)")
                            }
                            Spacer()
                            Image(systemName: "dot.radiowaves.right")
                        }
                    }
                    .padding(.vertical, 12)
                }
                .alert("Prescription Sent Successfully!", isPresented: $showPrescriptionSentSuccess) {
                    Button("Close", role: .cancel) {
                        showPrescriptionSentSuccess = false
                    }
                }
            }
        }
        .onAppear {
            if !hasAppeared {
                hasAppeared = true
                mcManager.start()
            }
        }
    }
}

//#Preview {
//    NearbyPatientsList()
//}
