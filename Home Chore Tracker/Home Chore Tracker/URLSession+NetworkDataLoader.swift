//
//  URLSession+NetworkDataLoader.swift
//  Home Chore Tracker
//
//  Created by Alex Shillingford on 2/7/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import Foundation

extension URLSession: NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
     
        self.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
}
