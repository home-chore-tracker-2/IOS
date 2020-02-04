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
    var parentRepresentation: ParentRepresentation {
        guard
            let username = username,
            let password = password,
            let id = id,
            let email = email
            else { return nil }
        
        @discardableResult convenience init(
    }
}
