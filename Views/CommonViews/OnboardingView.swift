//
//  OnboardingView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 16/01/25.
//

import SwiftUI

struct FeatureBlock: View {
    var icon: String
    var title: String
    var description: String
    var body: some View {
        HStack {
            VStack {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                    .font(.title)
            }
            .frame(width: 80, height: 80)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.callout)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}

struct OnboardingView: View {
    var body: some View {
        VStack {
            FeatureBlock(icon: "heart.text.square", title: "Create Prescriptions", description: "Doctors can quickly create, share, and manage prescriptions with an intuitive interface.")
            
            FeatureBlock(icon: "calendar.badge.clock", title: "Set Reminders", description: "Patients can easily set reminders on receiving prescriptions from their doctors.")
            
            FeatureBlock(icon: "person.line.dotted.person.fill", title: "Share with patient offline", description: "Doctors can share prescriptions with their patients wirelessly without any internet connection or WiFi.")
            
            FeatureBlock(icon: "accessibility", title: "Clear and Readable Prescriptions", description: "Say goodbye to confusion with organized, easy-to-read digital prescriptions that can be saved as PDFs effortlessly.")
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    OnboardingView()
}
