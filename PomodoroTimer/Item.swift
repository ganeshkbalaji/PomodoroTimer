//
//  Item.swift
//  PomodoroTimer
//
//  Created by Ganesh Balaji on 1/28/24.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    @NSManaged public var timestamp: Date
}
