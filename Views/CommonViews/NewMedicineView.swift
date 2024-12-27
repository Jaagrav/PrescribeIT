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
                HStack {
                    Text("Quantity")
                        .font(.callout)
                    Spacer()
                    TextField("e.g. 25mg, 5ml", text: $medicine.quantity)
                        .font(.title2)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Section("Schedule") {
                MedicineScheduleSetter(schedule: medicine.schedule)
            }
            
            Section("Notes") {
                TextField("e.g. Take medicine after dinner", text: $medicine.notes, axis: .vertical)
                    .font(.title2)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity, alignment: .topLeading)
            }
            
            Button("Save", systemImage: "checkmark") {
                showDrawer = false
            }
            
            Button("Delete", systemImage: "trash", role: .destructive) {
                removeMedicine(medicine)
                showDrawer = false
            }
            .foregroundColor(.red)
        }
        .listStyle(.grouped)
    }
}
