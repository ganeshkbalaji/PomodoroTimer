//
//  PomodoroTimerApp.swift
//  PomodoroTimer
//
//  Created by Ganesh Balaji on 1/28/24.
//

import SwiftUI
import SwiftData

@main
struct PomodoroTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

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
    
    var modelContainer: ModelContainer {
        PomodoroTimerApp.sharedModelContainer
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize the status bar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: 24)
        let modelContainer = PomodoroTimerApp.sharedModelContainer


        if let button = statusBarItem.button {
            button.image = NSImage(named: "tomato") // Use the name of your image asset here
            button.action = #selector(togglePopover(_:))
        }

        // Initialize the popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 200, height: 200)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView(modelContainer: modelContainer))
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusBarItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}
