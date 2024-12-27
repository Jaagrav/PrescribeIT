//
//  SymptomListItem.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 25/12/24.
//

import SwiftUI

struct SymptomListItem: View {
    @Binding var symptom: Symptom
    @State var showDrawer = false
    var removeSymptom: (Symptom) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(symptom.description)
                .fontWeight(.medium)
            if symptom.notes != "" {
                Text("Notes: \(symptom.notes)")
                    .font(.caption)
            }
        }
        .swipeActions {
            Button(role: .destructive) {
                removeSymptom(symptom)
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
        .contextMenu {
            Button("Edit", systemImage: "pencil") {
                showDrawer = true
            }
            Button("Delete", systemImage: "trash", role: .destructive) {
                removeSymptom(symptom)
            }
        }
        .sheet(isPresented: $showDrawer, onDismiss: {
            if symptom.description == "" && symptom.notes == "" {
                removeSymptom(symptom)
            }
        }) {
            NewSymptomView(symptom: $symptom, showDrawer: $showDrawer, isEditing: true, removeSymptom: removeSymptom)
        }
    }
}
