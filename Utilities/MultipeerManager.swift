//
//  MultipeerManager.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 28/12/24.
//

import MultipeerConnectivity
import Foundation

struct Peer: Equatable, Hashable {
    let peerID: MCPeerID
    let age: String
    let gender: String
    let name: String
    let userType: String
}

class MultipeerManager: NSObject, ObservableObject {
    private let serviceType = "prescribeit"
    private var myPeerID: MCPeerID
    private var session: MCSession
    private var advertiser: MCNearbyServiceAdvertiser
    private var browser: MCNearbyServiceBrowser
    
    @Published var discoveredPeers: [Peer] = []
    @Published var receivedPrescription: Prescription?
    
    init(user: User, userType: String) {
        self.myPeerID = MCPeerID(displayName: "\(user.firstName) \(user.lastName)")
        self.session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        self.advertiser = MCNearbyServiceAdvertiser(
            peer: myPeerID,
            discoveryInfo: ["userType": user.userType.rawValue, "age": user.age, "gender": user.gender.rawValue],
            serviceType: serviceType
        )
        self.browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        super.init()
        self.session.delegate = self
        self.advertiser.delegate = self
        self.browser.delegate = self
    }
    
    func start() {
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    func stop() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        session.disconnect()
    }
    
    func send(peerId: MCPeerID, prescription: Prescription) {
        guard let data = try? JSONEncoder().encode(prescription) else {
            print("Failed to encode prescription")
            return
        }
        try? session.send(data, toPeers: [peerId], with: .reliable)
    }
        
    func reset(user: User, userType: String) {
        stop()
        self.myPeerID = MCPeerID(displayName: "\(user.firstName) \(user.lastName)")
        self.session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        self.advertiser = MCNearbyServiceAdvertiser(
            peer: myPeerID,
            discoveryInfo: ["userType": user.userType.rawValue, "age": user.age, "gender": user.gender.rawValue],
            serviceType: serviceType
        )
        self.browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        self.session.delegate = self
        self.advertiser.delegate = self
        self.browser.delegate = self
        start()
    }
}

extension MultipeerManager: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let prescription = try? JSONDecoder().decode(Prescription.self, from: data) {
            prescription.uid = UUID()
            self.receivedPrescription = prescription
            print("Received prescription from \(peerID.displayName)")
        }
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

extension MultipeerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension MultipeerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        guard let info = info,
              let age = info["age"],
              let gender = info["gender"],
              let userType = info["userType"] else {
            print("Missing discovery info for peer: \(peerID.displayName)")
            return
        }

        let newPeer = Peer(peerID: peerID, age: age, gender: gender, name: peerID.displayName, userType: userType)

        if !self.discoveredPeers.contains(where: { $0.peerID == peerID }) {
            self.discoveredPeers.append(newPeer)
            print("Discovered peer: \(newPeer)")
        }

        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 20)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        self.discoveredPeers.removeAll { $0.peerID == peerID }
        print("Lost peer: \(peerID.displayName)")
    }
}
