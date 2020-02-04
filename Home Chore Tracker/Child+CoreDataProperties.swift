//
//  Child+CoreDataProperties.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/3/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//
//

import Foundation
import CoreData


extension Child {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Child> {
        return NSFetchRequest<Child>(entityName: "Child")
    }

    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var points: Int64
    @NSManaged public var cleanStreak: Int64
    @NSManaged public var childID: Int64
    @NSManaged public var chores: NSSet?
    @NSManaged public var parent: Parent?

}

// MARK: Generated accessors for chores
extension Child {

    @objc(addChoresObject:)
    @NSManaged public func addToChores(_ value: Chore)

    @objc(removeChoresObject:)
    @NSManaged public func removeFromChores(_ value: Chore)

    @objc(addChores:)
    @NSManaged public func addToChores(_ values: NSSet)

    @objc(removeChores:)
    @NSManaged public func removeFromChores(_ values: NSSet)

}
