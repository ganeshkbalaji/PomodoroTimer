//
//  PomodoroTimerApp.swift
//  PomodoroTimer
//
//  Created by Ganesh Balaji on 1/28/24.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct PomodoroTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // No WindowGroup needed for a menu bar app
        Settings {
            // Settings content
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
    var timer: Timer?
    var timerMenuItem: NSMenuItem?
    var endTime: Date?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize the status bar item

        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusBarItem.button {
            button.image = NSImage(named: "tomato") // Use the name of your image asset here
            button.target = self
            button.action = #selector(statusBarButtonClicked(_:))
        }

        // Initialize the popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 200, height: 200)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView()) // Modified ContentView
        
        // Check and request notification permission
        checkAndRequestNotificationPermission()
    }
    
    @objc func statusBarButtonClicked(_ sender: AnyObject?) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            if let button = statusBarItem.button {
                if statusBarItem.menu == nil {
                    // Construct and set the menu only if it's nil
                    let menu = constructMenu()
                    statusBarItem.menu = menu
                    button.performClick(nil) // Open the menu programmatically
                } else {
                    // Menu is already showing, now we want to show the popover
                    statusBarItem.menu = nil // Reset the menu so the button's action is called on next click
                    popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                }
            }
        }
    }
    
    func checkAndRequestNotificationPermission() {
        print("Is this being triggered")
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                print("Is this being triggered2")
                if settings.authorizationStatus != .authorized {
                    print("Is this being triggered3")
                    // Permissions have not been granted, request them
                    self.requestNotificationPermission()
                }
            }
        }

    func requestNotificationPermission() {
        print("Is this being triggered4")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Is this being triggered5")
                print("Notification permission granted.")
            } else if let error = error {
                print("Is this being triggered6")
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Is this being triggered7")
                print("Notification permission denied.")
            }
        }
    }

    func constructMenu() -> NSMenu {
            let menu = NSMenu()

            // Add Pomodoro Timer Item
            menu.addItem(NSMenuItem(title: "Pomodoro Timer", action: nil, keyEquivalent: ""))

            // Add a separator
            menu.addItem(NSMenuItem.separator())

            // Add Settings Item
            menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))

            // Add Quit Item
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

            return menu
        }
    
    @objc func openSettings() {
        // You would present a settings interface to the user here. For simplicity, we'll just use a dialog to set the timer.
        let alert = NSAlert()
        alert.messageText = "Set Timer"
        alert.informativeText = "Select the number of minutes and seconds:"
        
        let minutesLabel = NSTextField(labelWithString: "Minutes:")
        minutesLabel.frame = NSRect(x: 0, y: 40, width: 200, height: 24)

        let minutesDropdown = NSPopUpButton(frame: NSRect(x: 0, y: 30, width: 200, height: 24))
        minutesDropdown.addItems(withTitles: ["0", "1", "2", "3", "4", "5", "10", "15", "20", "25"])

        let secondsLabel = NSTextField(labelWithString: "Seconds:")
        secondsLabel.frame = NSRect(x: 0, y: 0, width: 200, height: 24)

        let secondsDropdown = NSPopUpButton(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        secondsDropdown.addItems(withTitles: ["0", "15", "30", "45", "60"])

        let stackView = NSStackView(frame: NSRect(x: 0, y: 0, width: 200, height: 124))
        stackView.orientation = .vertical        
        stackView.addView(minutesLabel, in: .top)
        stackView.addView(minutesDropdown, in: .top)
        stackView.addView(secondsLabel, in: .bottom)
        stackView.addView(secondsDropdown, in: .bottom)

        alert.accessoryView = stackView
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        
        if response == .alertFirstButtonReturn {
            // Get the selected values
            let selectedMinutes = minutesDropdown.indexOfSelectedItem
            let selectedSeconds = secondsDropdown.indexOfSelectedItem * 15  // because the smallest increment is 15 seconds
            
            // Calculate total time in seconds
            let totalTimeInSeconds = selectedMinutes * 60 + selectedSeconds
            
            // Start the timer
            self.startTimer(seconds: totalTimeInSeconds)
        }
    }
    
    func startTimer(seconds: Int) {
        
        guard seconds > 0 else {
               print("Attempted to start a timer with a non-positive seconds value")
               return
           }
        
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.endTime = Date().addingTimeInterval(TimeInterval(seconds))
            print("End time set for: \(self.endTime!)") // Added logging

            // Initialize timer menu item
            self.updateTimerMenuItem(seconds: seconds)

            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimerDisplay), userInfo: nil, repeats: true)
            print("Timer started for \(seconds) seconds") // Corrected logging
               }
           }
    
    @objc func updateTimerDisplay() {
        DispatchQueue.main.async { // Ensure UI updates are on the main thread
            guard let endTime = self.endTime else {
                self.timerDidEnd()
                return
            }

            let remainingTime = Int(endTime.timeIntervalSinceNow)
            if remainingTime <= 0 {
                self.timerDidEnd()
            } else {
                let remainingMinutes = remainingTime / 60
                let remainingSeconds = remainingTime % 60
                let timerTitle = String(format: "%02d:%02d", remainingMinutes, remainingSeconds)

                // Update the button title to show the remaining time
                if let button = self.statusBarItem.button {
                    button.title = timerTitle
                }
            }
        }
    }

    func timerDidEnd() {
        // Invalidate the timer
        timer?.invalidate()
        timer = nil
        endTime = nil
        
        // Update the button to indicate the timer has ended
        if let button = self.statusBarItem.button {
            button.title = ""
        }

        // Schedule a notification for break time
        scheduleNotification(in: 0, title: "Pomodoro Timer", body: "Time's up! Take a 5-minute break.")

        // Start a 5-minute break timer
        startBreakTimer()
    }

    func updateTimerMenuItem(seconds: Int) {
        DispatchQueue.main.async { // Ensure UI updates are on the main thread
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60
            let title = String(format: "Timer: %02d:%02d", minutes, remainingSeconds)
            if self.timerMenuItem == nil {
                self.timerMenuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
                // Create the timer menu item and immediately insert it
                self.statusBarItem.menu?.insertItem(self.timerMenuItem!, at: 0)
            } else {
                self.timerMenuItem?.title = title
            }

            print("Timer menu item set: \(title)") // Added logging
        }
    }
    
    func scheduleNotification(in timeInterval: TimeInterval, title: String, body: String) {
        
        guard timeInterval > 0 else {
             print("Attempted to schedule a notification with a non-positive time interval")
             return
         }
        
        // Request authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Check if permission is granted
            if granted {
                // Create the content for the notification
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default

                // Create a trigger for the notification
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

                // Create a request for the notification
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                // Schedule the notification
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        // Handle any errors
                        print("Error scheduling notification: \(error)")
                    }
                }
            } else {
                // Handle the case when permission is not granted
                print("Permission not granted")
            }
        }
    }
    
    func startBreakTimer() {
        // Start a 5-minute timer for the break (300 seconds)
        startTimer(seconds: 300)
    }

}
