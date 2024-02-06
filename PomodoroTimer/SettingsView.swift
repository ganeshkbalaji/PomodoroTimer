//
//  SettingsView.swift
//  PomodoroTimer
//
//  Created by Ganesh Balaji on 2/2/24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @State private var timers: [PomodoroTimer] = [] // This holds your timer data
    @State private var showingTimerConfig = false // To show/hide timer configuration view

    var body: some View {
        NavigationView {
            List {
                ForEach(timers, id: \.id) { timer in
                    TimerRow(timer: timer) // Display each timer
                }
                .onDelete(perform: deleteTimer)
            }
            .navigationTitle("Timers")
            .toolbar {
                Button(action: { showingTimerConfig = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingTimerConfig) {
                TimerConfigView(addTimerAction: addTimer)
            }
        }
    }

    func addTimer(name: String, duration: Int) {
        // Logic to add a new timer
        let newTimer = PomodoroTimer(id: UUID(), name: name, duration: duration)
        timers.append(newTimer)
        // Save to persistent storage as needed
    }

    func deleteTimer(at offsets: IndexSet) {
        // Delete the timer from the list and from persistent storage
    }
}

// View for configuring a new timer
struct TimerConfigView: View {
    @State private var selectedMinutes: Int = 0
    @State private var selectedSeconds: Int = 0
    var addTimerAction: (String, Int) -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Picker("Minutes", selection: $selectedMinutes) {
                ForEach(0..<60) { Text("\($0) min").tag($0) }
            }
            Picker("Seconds", selection: $selectedSeconds) {
                ForEach([0, 15, 30, 45, 60], id: \.self) { Text("\($0) sec").tag($0) }
            }
            HStack {
                Button("OK") {
                    addTimerAction("New Timer", selectedMinutes * 60 + selectedSeconds)
                    dismiss()
                }
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .padding()
    }
}

// Represent a single timer row
struct TimerRow: View {
    var timer: PomodoroTimer

    var body: some View {
        HStack {
            Text(timer.name)
            Spacer()
            Text("\(timer.duration) min")
        }
    }
}

// Model for the Pomodoro Timer
struct PomodoroTimer: Identifiable {
    var id: UUID
    var name: String
    var duration: Int // duration in minutes
}
