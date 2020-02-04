//
//  Parent+Convenience.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/3/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import Foundation
import CoreData

extension Parent {
    var parentRepresentation: ParentRepresentation? {
        guard
            let username = username,
            let password = password,
            let email = email,
            let children = children
            else { return nil }
        var childrenArray = [ChildRepresentation]()
        for child in children {
            if let child = child as? Child {
                childrenArray.append(ChildRepresentation(id: child.id, points: <#T##Int#>, cleanStreak: <#T##Int#>, username: <#T##String#>, password: <#T##String#>, chores: <#T##[ChoreRepresentation]#>))
            }
        }
        
        return ParentRepresentation(id: Int(id), username: username, password: password, email: email, children: children)
    }
}
    
