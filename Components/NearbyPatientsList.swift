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
    
    var body: some View {
        Section("Share with Nearby Patients") {
            if mcManager.discoveredPeers.isEmpty {
               Text("No patient devices found nearby")
            } else {
               ForEach(mcManager.discoveredPeers, id: \.self) { peer in
                   Button {
                       mcManager.send(peerId: peer.peerID, prescription: prescription)
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
//                           .foregroundColor(.primary)
                       }
                   }
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

//#Preview {
//    NearbyPatientsList()
//}
