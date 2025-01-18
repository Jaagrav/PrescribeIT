//
//  CallListView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 16/01/25.
//

import SwiftUI

struct DoctorListItem: View {
    var doctor: Doctor
    
    var body: some View {
        Link(destination: URL(string: "tel:\(doctor.phoneNumber)")!) {
            HStack {
                Image(systemName: "coat.fill")
                    .font(.title)
                    .padding(2)
                
                VStack(alignment: .leading) {
                    Text("Dr \(doctor.fullName)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                    Text("\(doctor.speciality) • \(doctor.phoneNumber)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "phone")
            }
            .foregroundColor(.primary)
            .padding(.vertical, 12)
        }
    }
}

struct CallListItem: View {
    var title: String
    var number: String
    var icon: String
    var desc: String
        
    var body: some View {
        Link(destination: URL(string: "tel:\(number)")!) {
            HStack {
                VStack {
                    HStack {
                        Image(icon)
                            .resizable()
                            .frame(maxWidth: 58, maxHeight: 60)
                            .cornerRadius(14)
                        VStack(alignment: .leading) {
                            Text(number)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.accentColor)
                            Text(title)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    HStack {
                        Text(desc)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                        Spacer()
                    }
                }
                .padding(.vertical, 12)
                .foregroundColor(.primary)
                Spacer()
                Image(systemName: "phone")
            }
        }
    }
}

struct CallListView: View {
    @Binding var showDrawer: Bool
    var sharedPrescriptions = Prescriptions.shared
    
    func getDoctors() -> [Doctor] {
        var foundDoctors: [Doctor] = []
        for prescription in sharedPrescriptions.prescriptions {
            var doctorFound = false
            
            for doctor in foundDoctors {
                if doctor.phoneNumber == prescription.doctor.phoneNumber {
                    doctorFound = true
                    break
                }
            }
            
            if !doctorFound {
                foundDoctors.append(prescription.doctor)
            }
        }
        return foundDoctors
    }
    
    var body: some View {
        HStack {
            Text("Call for Help")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Button("Close", role: .destructive) {
                showDrawer = false
            }
            .foregroundColor(.red)
            .buttonStyle(.plain)
        }
        .padding(20)
        .padding(.bottom, -8)
        
        HStack {
            Text("Find below a list of all known doctors and emergency services that you can reach out to for immediate help")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        
        List {
            if !getDoctors().isEmpty {
                Section("Known Doctors") {
                    ForEach(getDoctors()) { doctor in
                        DoctorListItem(doctor: doctor)
                    }
                }
            }
            Section("Emergency Services") {
                CallListItem(title: "Apollo Hospital", number: "1066", icon: "ApolloLogo", desc: "Emergency Hotline for Apollo Multispeciality Hospitals.")
                CallListItem(title: "Mental Health & Suicide Prevention", number: "9820466726", icon: "SuicidePrevention", desc: "A 24/7 helpline providing emotional support for individuals facing mental health challenges.")
                CallListItem(title: "De-Addiction Helpline", number: "1800-11-0031", icon: "DeaddictionServices", desc: "National helpline for substance abuse and de-addiction support.")
                CallListItem(title: "Ambulance Services", number: "108", icon: "EmergencyServices", desc: "A toll-free emergency service number for ambulance, fire, and police services across India.")
            }
        }
        .listStyle(.insetGrouped)
    }
}
