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
        "Saturday"
    ]
    
    var customDateBinding: Binding<Date> {
        Binding(
            get: {
                let component = DateComponents(hour: schedule.hour, minute: schedule.minutes)
                return Calendar.current.date(from: component) ?? Date()
            },
            set: { newValue in
                let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                schedule.hour = components.hour ?? 0
                schedule.minutes = components.minute ?? 0
            }
        )
    }

    var body: some View {
        HStack {
            Toggle("Save of Soul", isOn: $schedule.isSOS)
                .toggleStyle(.switch)
                .font(.callout)
        }
        HStack {
            Text("Time")
                .font(.callout)
            Spacer()
            DatePicker("Time", selection: customDateBinding, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(.compact)
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
                            schedule.days.contains(day) ? Color.accentColor : Color(uiColor: .secondarySystemBackground)
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
                            print(schedule.days)
                        }
                    }
                }
            }
        }
    }
}
