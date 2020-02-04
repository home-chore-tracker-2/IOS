//
//  ChoreRepresentation.swift
//  Home Chore Tracker
//
//  Created by Alex Shillingford on 2/3/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import Foundation

struct ChoreRepresentation: Codable {
    var id, childID, points, bonusPoints: Int
    var choreName, description: String
    var dueDate: Date
    var picture: URL
    var completed: Bool
}
