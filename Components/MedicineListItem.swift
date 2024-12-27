//
//  MedicineListItem.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 25/12/24.
//

import SwiftUI
import SwifCron

struct MedicineListItem: View {
    @Binding var medicine: Medicine
    @State var showDrawer = false
    var removeMedicine: (Medicine) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(medicine.name)
                .fontWeight(.medium)
            Text("\(getMedicineScheduleString(medicine: medicine))\(getMedicineScheduleString(medicine: medicine) != "" && medicine.quantity != "" ? "• " : "")\(medicine.quantity)")
                .font(.caption)
            if medicine.notes != "" { 
                Text("Notes: \(medicine.notes)")
                    .font(.footnote)
            }
        }
        .contextMenu {
            Button("Edit", systemImage: "pencil") {
                showDrawer = true
            }
            Button("Delete", systemImage: "trash", role: .destructive) {
                removeMedicine(medicine)
            }
        }
        .swipeActions {
            Button(role: .destructive) {
                removeMedicine(medicine)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            Button {
                showDrawer = true
            } label: {
                Label("Edit", systemImage: "pencil")
                    .tint(Color.accentColor)
            }
        }
        .sheet(isPresented: $showDrawer, onDismiss: {
            if medicine.name == "" {
                removeMedicine(medicine)
            }
        }) {
            NewMedicineView(medicine: $medicine, showDrawer: $showDrawer, isEditing: true, removeMedicine: removeMedicine)
        }
    }
}
