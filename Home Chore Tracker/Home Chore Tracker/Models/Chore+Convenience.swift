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
    
    @discardableResult convenience init(id: Int64,
                                        points: Int64,
                                        bonusPoints: Int64?,
                                        choreName: String,
                                        description: String,
                                        dueDate: Date,
                                        picture: URL?,
                                        completed: Bool,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        

        
        self.init(context: context)
        self.id = id
        self.points = points
        self.bonusPoints = bonusPoints ?? 0
        self.choreName = choreName
        self.choreDescription = description
        self.dueDate = dueDate
        self.picture = picture
        self.completed = completed
    }
    
    @discardableResult convenience init?(choreRepresentation: ChoreRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        

        
        self.init(id: Int64(choreRepresentation.id),
                  points: Int64(choreRepresentation.points),
                  bonusPoints: Int64(choreRepresentation.bonusPoints ?? 0),
                  choreName: choreRepresentation.choreName,
                  description: choreRepresentation.description,
                  dueDate: choreRepresentation.dueDate,
                  picture: choreRepresentation.picture!, // TODO: safely unwrap
                  completed: choreRepresentation.completed,
                  context: context)
    }
}
