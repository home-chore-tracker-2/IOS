//
//  ModelController.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/4/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class ChoreTrackerController {
    
    private let baseURL = URL(string: "https://chore-tracker-build.herokuapp.com/api/")!
    
    private var bearer: Bearer?
    
    private let encoder = JSONEncoder()
    
    private let decoder = JSONDecoder()
    
    var isUserLoggedIn: Bool {
        if bearer == nil {
            return false
        } else {
            return true
        }
    }
    
    func register(with parent: ParentRepresentation, completion: @escaping (Error?) -> Void) {
        
        let signUpURL = baseURL.appendingPathComponent("auth/register")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonUserData = try encoder.encode(parent)
            request.httpBody = jsonUserData
        } catch {
            NSLog("Error encoding parent object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                NSLog("HTTP URL register response: \(response)")
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func login(with parent: ParentRepresentation, completion: @escaping (Error?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("auth/login")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonUserData = try encoder.encode(parent)
            request.httpBody = jsonUserData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("HTTP URL Login Response: \(response)")
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            guard let data = data else {
                completion(NSError())
                return
            }
            do {
                self.bearer = try self.decoder.decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
