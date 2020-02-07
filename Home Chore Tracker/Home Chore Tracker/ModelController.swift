//
//  ModelController.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/4/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
    
    var newUserID: Int = 12
    
//    private let encoder = JSONEncoder()
    
//    private let decoder = JSONDecoder()
    
    var children: [ChildRepresentation]?
    
    private let context = CoreDataStack.shared.container.newBackgroundContext()
    
    var childID: Int = 0
    
    var choresSet: NSSet?
    
    typealias CompletionHandler = (Error?) -> Void
    
    var isUserLoggedIn: Bool {
        if bearer == nil {
            return false
        } else {
            return true
        }
    }
    
    init() {
        fetchChores()
    }
    
    func parentSignUp(user: User, completion: @escaping (Error?) -> Void) {
        let signUpURL = baseURL.appendingPathComponent("auth/register")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonUserInfo = try JSONEncoder().encode(user)
            request.httpBody = jsonUserInfo
        } catch {
            NSLog("Error encoding parent representation object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                NSLog("HTTP URL parent register response: \(response)")
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                NSLog("Error with user sign up: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func parentLogin(user: User, completion: @escaping (Error?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("auth/login")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonUserData = try JSONEncoder().encode(user)
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
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func childSignUp(child: ChildUser, completion: @escaping (Error?) -> Void) {
        guard let bearer = bearer else { return }
        
        let signUpURL = baseURL.appendingPathComponent("child")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonChildUserData = try JSONEncoder().encode(child)
            request.httpBody = jsonChildUserData
        } catch {
            NSLog("Error encoding child object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                NSLog("HTTP URL child register response: \(response)")
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
                
                let childRep = try JSONDecoder().decode(ChildRepresentation.self, from: data)
                
                Child(childRepresentation: childRep, context: self.context)
                try CoreDataStack.shared.save(context: self.context)
            } catch {
                NSLog("Error decoding data \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func childLogin(with child: ChildUser, completion: @escaping (Error?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("auth/login/child")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonUserData = try JSONEncoder().encode(child)
            request.httpBody = jsonUserData
        } catch {
            NSLog("Error encoding child object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("HTTP URL child login response: \(response)")
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
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
     // MARK: - Core Data Methods
    
//    func fetchChildren(completion: @escaping CompletionHandler = { _ in }) {
//        guard let bearer = bearer else { return }
//
//        let userWithChildrenURL = baseURL.appendingPathComponent("child")
//        var request = URLRequest(url: userWithChildrenURL)
//        request.httpMethod = HTTPMethod.get.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
//                NSLog("HTTP URL GET request response: \(response)")
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//                return
//            }
//            if let error = error {
//                NSLog("Error GETing user and children data: \(error)")
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//                return
//            }
//            guard let data = data else {
//                NSLog("No data returned by data task")
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//                return
//            }
//            do {
//                let parentRep = try JSONDecoder().decode(ParentRepresentation.self, from: data)
//                Parent(parentRepresentation: parentRep)
//                try CoreDataStack.shared.save(context: self.context)
//            } catch {
//                NSLog("Error decoding parent representation object: \(error)")
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//                return
//            }
//        }.resume()
//    }
    
    func fetchChores(completion: @escaping CompletionHandler = { _ in }) {
        guard let bearer = bearer else { return }
        
        var chores: [Chore] = []
        
        let allChoresURL = baseURL.appendingPathComponent("chores")
        
        var request = URLRequest(url: allChoresURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                NSLog("Response from fetching chores \(response)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            if let error = error {
                NSLog("Error fetching chores data: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            guard let data = data else {
                NSLog("No data returned by data task")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            do {
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let choresRep = try decoder.decode([ChoreRepresentation].self, from: data)
                    for choreRep in choresRep {
                        if let chore = Chore(choreRepresentation: choreRep, context: self.context) {
                            chores.append(chore)
                        }
                    }
                
                if chores.count > 0 {
                    self.choresSet = NSSet(array: chores)
                }
                try CoreDataStack.shared.save(context: self.context)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                NSLog("Error decoding chore objects: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
        }.resume()
    }
    
    func putChore(with image: UIImage, childRep: inout ChildRepresentation, childID: Int, choreID: Int, completion: @escaping (NetworkError?) -> Void) {
        guard let bearer = bearer else {
            completion(.badAuth)
            return
        }
        let imageData = image.pngData()
        
//        childRep.chores?[choreID].picture = imageData
        
        let requestURL = baseURL.appendingPathComponent("child").appendingPathComponent("\(childID)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonChildInfo = try JSONEncoder().encode(childRep)
            request.httpBody = jsonChildInfo
        } catch {
            NSLog("Error encoding child info to PUT: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("\(error)")
                completion(.otherError)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("HTTPURLResponse status code was not 200. Response status code was \(response.statusCode)")
                completion(.otherError)
                return
            }
        }.resume()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
//    func deleteParent(for parent: Parent) {
//        CoreDataStack.shared.mainContext.delete(parent)
//        saveToPersistentStore()
//    }
//
//    func deleteChild(for child: Child) {
//        CoreDataStack.shared.mainContext.delete(child)
//        saveToPersistentStore()
//    }
    
    func deleteObject(for object: NSManagedObject) {
        CoreDataStack.shared.mainContext.delete(object)
        saveToPersistentStore()
    }
    
    func updateParent(for parent: Parent, with representation: ParentRepresentation) {
        guard
            let repID = representation.id,
            let children = representation.children
            else { return }
        parent.id = Int64(repID)
        parent.username = representation.username
        parent.email = representation.email
        parent.children = NSSet(object: children)
        saveToPersistentStore()
    }
    
    func updateChild(for child: Child, with representation: ChildRepresentation) {
        guard
            let points = representation.points,
            let cleanStreak = representation.cleanStreak,
            let chores = representation.chores
            else { return }
        child.childID = Int64(representation.id)
        child.username = representation.username
        child.cleanStreak = cleanStreak
        child.points = Int64(points)
        child.chores = NSSet(object: chores)
        saveToPersistentStore()
    }
    
    func updateChore(for chore: Chore, with representation: ChoreRepresentation) {
        
        
        chore.id = Int64(representation.id)
        chore.choreName = representation.choreName
        chore.choreDescription = representation.description
        chore.dueDate = representation.dueDate
        chore.points = Int64(representation.points)
        chore.bonusPoints = Int64(representation.bonusPoints ?? 0)
        chore.picture = representation.picture
        chore.completed = representation.completed
        saveToPersistentStore()
    }
}
