//
//  Child+Convenience.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/4/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import Foundation
import CoreData

extension Child {
    var childRepresentation: ChildRepresentation? {
        guard
            let username = username,
            let password = password
            else { return nil }
        
        var choresArray = [ChoreRepresentation]()
        
        if let chores = chores {
            for chore in chores {
                if let chore = chore as? Chore, let choreRep = chore.choreRepresentation {
                    choresArray.append(choreRep)
                }
            }
        }
        return ChildRepresentation(id: Int(childID), points: Int(points), cleanStreak: cleanStreak, username: username, password: password, chores: choresArray)
    }
    
    @discardableResult convenience init(id: Int64,
                                        points: Int64,
                                        cleanStreak: Bool,
                                        username: String,
                                        password: String,
                                        chores: NSSet?,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.childID = id
        self.points = points
        self.cleanStreak = cleanStreak
        self.username = username
        self.password = password
        self.chores = chores
    }
    
    @discardableResult convenience init?(childRepresentation: ChildRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        var chores: [Chore] = []
        
        if let choresRep = childRepresentation.chores, choresRep.count > 0 {
            for choreRep in choresRep {
                if let chore = Chore(choreRepresentation: choreRep, context: context) {
                    chores.append(chore)
                }
            }
        }
        
        var choresSet: NSSet?
        
        if chores.count > 0 {
            choresSet = NSSet(array: chores)
        }
        
        self.init(id: Int64(childRepresentation.id),
        points: Int64(childRepresentation.points ?? 0),
                  cleanStreak: childRepresentation.cleanStreak ?? false,
                  username: childRepresentation.username,
                  password: childRepresentation.password,
                  chores: choresSet,
                  context: context)
    }
}
