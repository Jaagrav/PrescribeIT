//
//  NetworkIssuesHelper.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 24/02/25.
//

import SwiftUI
import AVKit

struct HelperVideo: View {
    private let player: AVQueuePlayer
    private let looper: AVPlayerLooper?

    init() {
        if let url = Bundle.main.url(forResource: "LocalNetworkSwitch", withExtension: "mp4") {
            let asset = AVAsset(url: url)
            let item = AVPlayerItem(asset: asset)
            self.player = AVQueuePlayer()
            self.looper = AVPlayerLooper(player: player, templateItem: item)
            self.player.play()
        } else {
            self.player = AVQueuePlayer()
            self.looper = nil
        }
    }

    var body: some View {
        VideoPlayer(player: player)
            .frame(height: 150)
            .cornerRadius(12)
    }
}

struct NetworkIssuesHelper: View {
    @State var isOpen = false
    var body: some View {
        HStack {
            Button {
                isOpen.toggle()
            } label: {
                HStack {
                    Image(systemName: "info.circle")
                    Text("Facing issues?")
                }
            }
        }.sheet(isPresented: $isOpen) {
            VStack(alignment: .leading) {
                Text("Troubleshooting")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Text("I am unable to send prescriptions to patients?")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding(.vertical, 8)
                
                Text("Make sure you have permitted PrescribeIT to have access to your local network")
                    .padding(.bottom, 8)
                Text("- Open **Settings**")
                Text("- Go to **Apps**")
                Text("- Go to **PrescribeIT**")
                Text("- Toggle **Local Network** switch")
                
                HelperVideo()
                    .padding(.top, 12)
                
                Button {
                    if let url = URL(string: "app-settings:root=General"),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    VStack {
                        Text("Open Settings")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                            .padding(.top, 12)
                    }
                }
                
                Spacer()
            }
            .padding(24)
        }
    }
}

#Preview {
    NetworkIssuesHelper()
}
