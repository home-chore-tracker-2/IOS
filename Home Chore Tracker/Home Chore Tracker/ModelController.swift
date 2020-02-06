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

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case noEncode
}

class ChoreTrackerController {
    
    private let baseURL = URL(string: "https://chore-tracker-build.herokuapp.com/api/")!
    
    private var bearer: Bearer?
    
    private let encoder = JSONEncoder()
    
    private let decoder = JSONDecoder()
    
    var parentRep: ParentRepresentation?
    
    var isUserLoggedIn: Bool {
        if bearer == nil {
            return false
        } else {
            return true
        }
    }
    
    func parentRegister(with parent: ParentRepresentation, completion: @escaping (Error?) -> Void) {
        
        let signUpURL = baseURL.appendingPathComponent("auth/register")
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
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
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                NSLog("HTTP URL parent register response: \(response)")
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Bad data")
                completion(error)
                return
            }
            do {
                try self.parentRep = JSONDecoder().decode(ParentRepresentation.self, from: data)
            } catch {
                NSLog("Error decoding data \(error)")
                completion(error)
                return 
            }
            completion(nil)
        }.resume()
    }
    
    func parentLogin(with parent: ParentRepresentation, completion: @escaping (Error?) -> Void) {
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
                NSLog("HTTP URL parent login response: \(response)")
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
    
    func childRegister(with child: ChildRepresentation, completion: @escaping (Error?) -> Void) {
        
        let signUpURL = baseURL.appendingPathComponent("auth/register/child")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonUserData = try encoder.encode(child)
            request.httpBody = jsonUserData
        } catch {
            NSLog("Error encoding child object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                NSLog("HTTP URL child register response: \(response)")
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
    
    func childLogin(with child: ChildRepresentation, completion: @escaping (Error?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("auth/login/child")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonUserData = try encoder.encode(child)
            request.httpBody = jsonUserData
        } catch {
            NSLog("Error encoding child object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("HTTP URL parent login response: \(response)")
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
    
//     MARK: - Core Data Methods
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    func deleteParent(for parent: Parent) {
        CoreDataStack.shared.mainContext.delete(parent)
        saveToPersistentStore()
    }
    
    func deleteChild(for child: Child) {
        CoreDataStack.shared.mainContext.delete(child)
        saveToPersistentStore()
    }
    
    func deleteChore(for chore: Chore) {
        CoreDataStack.shared.mainContext.delete(chore)
        saveToPersistentStore()
    }
    
    func updateParent(for parent: Parent, with representation: ParentRepresentation) {
        guard let repID = representation.id else { return }
        parent.id = Int64(repID)
        parent.username = representation.username
        parent.password = representation.password
        parent.email = representation.email
        parent.children = NSSet(object: representation.children)
        saveToPersistentStore()
    }
    
    func updateChild(for child: Child, with representation: ChildRepresentation) {
        child.childID = Int64(representation.id)
        child.username = representation.username
        child.password = representation.password
        child.cleanStreak = representation.cleanStreak
        child.points = Int64(representation.points)
        child.chores = NSSet(object: representation.chores)
        saveToPersistentStore()
    }
    
    func updateChore(for chore: Chore, with representation: ChoreRepresentation) {
        chore.id = Int64(representation.id)
        chore.choreName = representation.choreName
        chore.choreDescription = representation.description
        chore.dueDate = representation.dueDate
        chore.points = Int64(representation.points)
        chore.bonusPoints = Int64(representation.bonusPoints)
        chore.picture = representation.picture
        chore.completed = representation.completed
        saveToPersistentStore()
    }
}
