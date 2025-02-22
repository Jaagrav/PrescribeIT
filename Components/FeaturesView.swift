//
//  FeaturesView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 22/02/25.
//

import SwiftUI

struct FeaturesView: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome to")
                        .opacity(0.5)

                    Text("PrescribeIT")
                        .font(.system(size: 48))
                        .fontWeight(.bold)

                    Text("PrescribeIT is an app for both doctors and patients.")

                    FeatureBlock(icon: "heart.text.square", title: "Create Prescriptions", description: "Doctors can quickly create, share, and manage prescriptions with an intuitive interface.")

                    FeatureBlock(icon: "calendar.badge.clock", title: "Set Reminders at one click", description: "Patients can easily set reminders for all their medications at one click on receiving prescriptions from their doctors.")

                    FeatureBlock(icon: "person.line.dotted.person.fill", title: "Share with patient offline", description: "Doctors can share prescriptions with their patients wirelessly without any internet connection or WiFi.")

                    FeatureBlock(icon: "accessibility", title: "Clear and Readable Prescriptions", description: "Say goodbye to confusion with organized, easy-to-read digital prescriptions that can be saved as PDFs effortlessly.")
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .frame(maxWidth: 500)
        }
    }
}
