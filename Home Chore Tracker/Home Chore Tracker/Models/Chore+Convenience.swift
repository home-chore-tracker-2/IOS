//
//  Chore+Convenience.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/4/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import Foundation
import CoreData

extension Chore {
    var choreRepresentation: ChoreRepresentation? {
        guard
            let choreName = choreName,
            let choreDescription = choreDescription,
            let dueDate = dueDate,
            let picture = picture
            else { return nil }
        
        return ChoreRepresentation(id: Int(id), points: Int(points), bonusPoints: Int(bonusPoints), choreName: choreName, description: choreDescription, dueDate: dueDate, picture: picture, completed: completed)
    }
}
