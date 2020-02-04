//
//  Parent+CoreDataProperties.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/3/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//
//

import Foundation
import CoreData


extension Parent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Parent> {
        return NSFetchRequest<Parent>(entityName: "Parent")
    }

    @NSManaged public var id: Int64
    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var email: String?
    @NSManaged public var children: NSSet?

}

// MARK: Generated accessors for children
extension Parent {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: Child)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: Child)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}
