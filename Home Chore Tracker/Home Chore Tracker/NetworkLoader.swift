//
//  NetworkLoader.swift
//  Home Chore Tracker
//
//  Created by Alex Shillingford on 2/7/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import Foundation

protocol NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, Response?, Error?) -> Void)
}
