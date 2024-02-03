//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by Ganesh Balaji on 1/28/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Pomodoro Timer")
            // Your content
        }
        .frame(minWidth: 300, minHeight: 200)
        .toolbar {
            // This ToolbarItemGroup will appear on the trailing edge of the window
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    // Your action here
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
