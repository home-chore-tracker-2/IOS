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
    
    private let signUpURL = URL(string: "https://chore-tracker-build.herokuapp.com/api/auth/register")!
    
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
    
    func signUp(with parent: ParentRepresentation, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            let jsonUserData = try encoder.encode(parent)
            request.httpBody = jsonUserData
        } catch {
            NSLog("Error encoding parent object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
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
    
    func signIn(with parent: ParentRepresentation, completion: @escaping (Error?) -> Void) {
        let loginURL = URL(string: "https://chore-tracker-build.herokuapp.com/api/auth/login")!
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
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
