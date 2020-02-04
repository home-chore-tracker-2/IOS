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
        return ChildRepresentation(id: Int(childID), points: Int(points), cleanStreak: Int(cleanStreak), username: username, password: password, chores: choresArray)
    }
}
