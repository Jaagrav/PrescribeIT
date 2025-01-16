//
//  NewSymptomView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 25/12/24.
//

import SwiftUI

struct NewSymptomView: View {
    @Binding var symptom: Symptom
    @Binding var showDrawer: Bool
    var isEditing: Bool
    let removeSymptom: (Symptom) -> Void
    
    var body: some View {
        HStack {
            Text("\(isEditing ? "Edit" : "New") Complaint")
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
            Section("Complaint") {
                TextField("e.g. Fever, Chest pain", text: $symptom.description)
                    .font(.title2)
                    .padding(.vertical, 12)
            }
            Section("Notes") {
                TextField("e.g. Fever of over 100 degrees", text: $symptom.notes, axis: .vertical)
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
                removeSymptom(symptom)
                showDrawer = false
            }
            .padding(.vertical, 12)
            .foregroundColor(.red)
        }
        .listStyle(.insetGrouped)
    }
}

//#Preview {
//    @State var showDrawer = true
//    NewSymptomView(showDrawer: $showDrawer)
//}
