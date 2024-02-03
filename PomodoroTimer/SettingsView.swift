//
//  SettingsView.swift
//  PomodoroTimer
//
//  Created by Ganesh Balaji on 2/2/24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @State private var timers: [PomodoroTimer] = [] // This would hold your timer data, fetched from persistent storage

    var body: some View {
            NavigationView {
                List {
                    ForEach(timers, id: \.id) { timer in
                        TimerRow(timer: timer) // TimerRow is a custom view that displays the timer
                    }
                    .onDelete(perform: deleteTimer)
                }
                .navigationTitle("Timers")
                .toolbar {
                    // For macOS, you typically use `.automatic` or `.principal`
                    // ToolbarItem(placement: .navigationBarTrailing) is not used here
                    Button(action: addTimer) {
                        Image(systemName: "plus")
                    }
                }
            }
        }

    func addTimer() {
        // Present an interface to add a new timer
    }

    func deleteTimer(at offsets: IndexSet) {
        // Delete the timer from the list and from persistent storage
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
