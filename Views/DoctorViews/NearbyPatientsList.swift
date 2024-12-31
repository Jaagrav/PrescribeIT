//
//  NearbyPatientsList.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 29/12/24.
//

import SwiftUI
import MultipeerConnectivity

struct NearbyPatientsList: View {
    @StateObject private var mcManager = MultipeerManager(user: AppState.shared.user!, userType: "doctor")
    @StateObject var prescription: Prescription
    
    var body: some View {
        VStack {
            ForEach(mcManager.discoveredPeers, id: \.self) { peer in
                Button {
                    print(peer)
                    mcManager.send(peerId: peer, prescription: prescription)
                } label: {
                    Text(peer.displayName)
                }
            }
            if mcManager.discoveredPeers.count == 0 {
                Text("No patient devices found nearby")
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
