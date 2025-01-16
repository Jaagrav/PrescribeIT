//
//  CallListView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 16/01/25.
//

import SwiftUI

struct Doctor {
    var fullName: String
    var phoneNumber: String
    var speciality: String
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
                Spacer()
                Image(systemName: "phone")
            }
        }
    }
}

struct CallListView: View {
    var body: some View {
        HStack {
            Text("Call for Help")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(20)
        .padding(.bottom, -8)
        
        List {
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

#Preview {
    CallListView()
}
