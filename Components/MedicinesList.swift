//
//  MedicinesList.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 25/12/24.
//

import SwiftUI

struct MedicinesList: View {
    @Binding var medicines: [Medicine]
    @State var showDrawer = false
    
    func removeMedicine(medicine: Medicine) {
        for (index, i) in medicines.enumerated() {
            if i.uid == medicine.uid {
                medicines.remove(at: index)
            }
        }
    }
    
    var body: some View {
        ForEach($medicines) { $medicine in
            MedicineListItem(medicine: $medicine, removeMedicine: removeMedicine)
        }
        Button("Add Medicine", systemImage: "plus") {
            medicines.append(Medicine(schedule: MedicineSchedule(daypart: [], days: [], isSOS: false), name: "", quantity: "", notes: ""))
            showDrawer = true
        }
        .sheet(isPresented: $showDrawer, onDismiss: {
            let medicine = medicines[medicines.count - 1]
            if medicine.name == "" {
                removeMedicine(medicine: medicine)
            }
        }) {
            NewMedicineView(medicine: $medicines[medicines.count - 1], showDrawer: $showDrawer, isEditing: false, removeMedicine: removeMedicine)
        }
    }
}
