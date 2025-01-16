//
//  NewMedicineView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 25/12/24.
//

import SwiftUI

struct NewMedicineView: View {
    @Binding var medicine: Medicine
    @Binding var showDrawer: Bool
    var isEditing: Bool
    let removeMedicine: (Medicine) -> Void
    
    @State private var selectedDate = Date()
    
    var body: some View {
        HStack {
            Text("\(isEditing ? "Edit" : "New") Medicine")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Button("Close", role: .destructive) {
                showDrawer = false
            }
        }
        .padding(20)
        .padding(.bottom, -8)
        
        List {
            Section("Medicine Details") {
                HStack {
                    Text("Name")
                        .font(.callout)
                    Spacer()
                    TextField("e.g. Paracetamol, Aspirin", text: $medicine.name)
                        .font(.title2)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.vertical, 12)
                HStack {
                    Text("Quantity")
                        .font(.callout)
                    Spacer()
                    TextField("e.g. 25mg, 5ml", text: $medicine.quantity)
                        .font(.title2)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.vertical, 12)
            }
            
            Section("Schedule") {
                MedicineScheduleSetter(schedule: medicine.schedule)
                    .padding(.vertical, 12)
            }
            
            Section("Notes") {
                TextField("e.g. Take medicine after dinner", text: $medicine.notes, axis: .vertical)
                    .font(.title2)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.vertical, 12)
            }
            
            Button("Save", systemImage: "checkmark") {
                showDrawer = false
            }
            .padding(.vertical, 12)
            
            Button("Delete", systemImage: "trash", role: .destructive) {
                removeMedicine(medicine)
                showDrawer = false
            }
            .foregroundColor(.red)
            .padding(.vertical, 12)
        }
        .listStyle(.insetGrouped)
    }
}
