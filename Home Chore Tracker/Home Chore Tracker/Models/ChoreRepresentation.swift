//
//  ChoreRepresentation.swift
//  Home Chore Tracker
//
//  Created by Alex Shillingford on 2/3/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import Foundation

struct ChoreRepresentation: Codable {
    var id: String?
    var points: Int
    var bonusPoints: Int?
    var choreName: String
    var description: String
    var dueDate: Date
    var picture: String?
    var completed: Bool
    
}
