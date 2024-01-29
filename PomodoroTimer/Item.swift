//
//  Item.swift
//  PomodoroTimer
//
//  Created by Ganesh Balaji on 1/28/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
