//
//  ParentRepresentation.swift
//  Home Chore Tracker
//
//  Created by Alex Shillingford on 2/3/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import Foundation

struct ParentRepresentation: Codable {
    var id: Int?
    var username, email: String
    var children: [ChildRepresentation]? = []
}
