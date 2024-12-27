//
//  SymptomsList.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 25/12/24.
//

import SwiftUI

struct SymptomsList: View {
    @Binding var symptoms: [Symptom]
    @State var showDrawer = false
    
    func removeSymptom(symptom: Symptom) {
        for (index, i) in symptoms.enumerated() {
            if i.uid == symptom.uid {
                symptoms.remove(at: index)
            }
        }
    }
    
    var body: some View {
        ForEach($symptoms) { $symptom in
            SymptomListItem(symptom: $symptom, removeSymptom: removeSymptom)
        }
        Button("Add Complaint", systemImage: "plus") {
            symptoms.append(Symptom(description: "", notes: ""))
            showDrawer = true
        }
        .sheet(isPresented: $showDrawer, onDismiss: {
            let symptom = symptoms[symptoms.count - 1]
            if symptom.description == "" && symptom.notes == "" {
                removeSymptom(symptom: symptom)
            }
        }) {
            NewSymptomView(symptom: $symptoms[symptoms.count - 1], showDrawer: $showDrawer, isEditing: false, removeSymptom: removeSymptom)
        }
    }
}
