//
//  Chore+CoreDataProperties.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/3/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//
//

import Foundation
import CoreData


extension Chore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chore> {
        return NSFetchRequest<Chore>(entityName: "Chore")
    }

    @NSManaged public var id: Int64
    @NSManaged public var points: Int64
    @NSManaged public var bonusPoints: Int64
    @NSManaged public var choreName: String?
    @NSManaged public var choreDescription: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var completed: Bool
    @NSManaged public var picture: URL?
    @NSManaged public var child: Child?

}
