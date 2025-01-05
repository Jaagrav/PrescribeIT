//
//  PatientListItem.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 24/12/24.
//

import SwiftUI
import UIKit

struct PatientListItem: View {
    @Binding var prescription: Prescription
    
    var body: some View {
        NavigationLink(
            destination: PrescriptionBuilderView(prescription: $prescription)
        ) {
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
}
