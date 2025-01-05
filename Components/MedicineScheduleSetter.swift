//
//  MedicineScheduleSetter.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 26/12/24.
//

import SwiftUI

struct MedicineScheduleSetter: View {
    @StateObject var schedule: MedicineSchedule
    
    var days = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
    ]
    
    var dayParts = [
        "Morning",
        "Afternoon",
        "Evening",
        "Night"
    ]
    
    var body: some View {
        HStack {
            Toggle("Save of Soul", isOn: $schedule.isSOS)
                .toggleStyle(.switch)
                .font(.callout)
        }
        
        VStack {
            HStack {
                Text("Time")
                    .font(.callout)
                Spacer()
            }
            HStack {
                ForEach(dayParts, id: \.self) { dayPart in
                    HStack {
                        Text(dayPart)
                            .font(.footnote)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(schedule.daypart.contains(dayPart) ? Color(uiColor: .systemBackground) : Color.primary)
                    .background(
                        schedule.daypart.contains(dayPart) ? Color.accentColor : Color(uiColor: .tertiarySystemBackground)
                    )
                    .cornerRadius(12)
                    .onTapGesture {
                        if schedule.daypart.contains(dayPart) {
                            for (index, i) in schedule.daypart.enumerated() {
                                if i == dayPart {
                                    schedule.daypart.remove(at: index)
                                }
                            }
                        }
                        else {
                            schedule.daypart.append(dayPart)
                        }
                    }
                }
            }
        }
        
        VStack {
            HStack {
                Text("Scheduled Days")
                    .font(.callout)
                Spacer()
                Text("\(schedule.days.count) days")
                    .font(.footnote)
            }
            HStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                    ForEach(days, id: \.self) { day in
                        HStack {
                            Text(day)
                                .font(.footnote)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(schedule.days.contains(day) ? Color(uiColor: .systemBackground) : Color.primary)
                        .background(
                            schedule.days.contains(day) ? Color.accentColor : Color(uiColor: .tertiarySystemBackground)
                        )
                        .cornerRadius(12)
                        .onTapGesture {
                            if schedule.days.contains(day) {
                                for (index, i) in schedule.days.enumerated() {
                                    if i == day {
                                        schedule.days.remove(at: index)
                                    }
                                }
                            }
                            else {
                                schedule.days.append(day)
                            }
                        }
                    }
                }
            }
        }
    }
}
