//
//  PatientListItem.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 24/12/24.
//

import SwiftUI
import UIKit

struct PatientItem: View {
    @Binding var prescription: Prescription
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(UIColor.secondarySystemBackground), Color.gray]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay {
                            Text(prescription.patientName.prefix(2).uppercased())
                                .foregroundColor(.white)
                                .font(.title)
                        }
                }
                VStack(alignment: .leading) {
                    Text(prescription.patientName)
                        .font(.title2)
                    Text("\(prescription.vitals.age) years old • \(prescription.vitals.gender.rawValue.capitalized) • \(prescription.medicines.count) Medicines")
                        .lineLimit(1)
                }
                .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            
            Divider()
        }
    }
}

struct PatientListItem: View {
    @Binding var prescription: Prescription
    @Namespace var namespace
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationLink {
            if #available(iOS 18, *) {
                PrescriptionBuilderView(prescription: $prescription, path: $path)
                    .navigationTransition(.zoom(sourceID: "prescription", in: namespace))
            } else {
                PrescriptionBuilderView(prescription: $prescription, path: $path)
            }
        } label: {
            if #available(iOS 18, *) {
                PatientItem(prescription: $prescription)
                    .matchedTransitionSource(id: "prescription", in: namespace)
            } else {
                PatientItem(prescription: $prescription)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .background(.clear)
    }
}
