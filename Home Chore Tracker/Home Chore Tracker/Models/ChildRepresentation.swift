//
//  ChildRepresentation.swift
//  Home Chore Tracker
//
//  Created by Alex Shillingford on 2/3/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import Foundation

struct ChildRepresentation: Codable {
    var id: Int
    var points: Int? = 0
    var cleanStreak: Bool? = false
    var username: String
    var chores: [ChoreRepresentation]?
}
