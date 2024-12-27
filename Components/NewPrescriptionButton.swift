//
//  NewPrescriptionButton.swift
//  PrescribeIt
//
//  Created by Jaagrav Seal on 23/12/24.
//

import SwiftUI

struct NewPrescriptionButton: View {
    @State var showDrawer = false
    func createNewPrescription () {
        showDrawer = true
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: createNewPrescription) {
                    Image(systemName: "plus")
                        .font(.title)
                        .padding(18)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(100)
                }
            }
            .padding(.trailing, 24)
        }
        .sheet(isPresented: $showDrawer) {
            NewPrescriptionView(showDrawer: $showDrawer)
        }
    }
}

#Preview {
    NewPrescriptionButton()
}
