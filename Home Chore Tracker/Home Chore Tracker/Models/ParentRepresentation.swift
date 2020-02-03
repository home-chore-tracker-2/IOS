//
//  ParentRepresentation.swift
//  Home Chore Tracker
//
//  Created by Alex Shillingford on 2/3/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import Foundation

struct ParentRepresentation {
    var id: Int?
    var username, password, email: String
    var children: [ChildRepresentation]
}
