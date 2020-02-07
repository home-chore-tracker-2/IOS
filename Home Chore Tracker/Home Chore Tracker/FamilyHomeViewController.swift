//
//  FamilyHomeViewController.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/5/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import UIKit
import CoreData

class FamilyHomeViewController: UIViewController, UITableViewDataSource {
    
    let choreTrackerController = ChoreTrackerController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Child> = {
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "username", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    @IBOutlet weak var familyMembersTableView: UITableView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        familyMembersTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if choreTrackerController.isUserLoggedIn == false {
            performSegue(withIdentifier: "SignUpOrInModalSegue", sender: self)
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = familyMembersTableView.dequeueReusableCell(withIdentifier: "FamilyMemberCell", for: indexPath) as? FamilyMemberTableViewCell else { return UITableViewCell()}
        
        let child = fetchedResultsController.object(at: indexPath)
        cell.child = child
        cell.childNameLabel.text = child.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let count = fetchedResultsController.fetchedObjects?.count else { return nil }
        
        if count <= 1 {
            return "Child"
        } else {
            return "Children"
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = fetchedResultsController.object(at: indexPath)
            choreTrackerController.deleteObject(for: object)
        }
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpOrInModalSegue" {
            guard let signUpOrInVC = segue.destination as? RegisterAndLoginViewController else { return }
            signUpOrInVC.choreTrackerController = choreTrackerController
        } else if segue.identifier == "AddFamilyMemberSegue" {
            guard let addFamilyMemberVC = segue.destination as? AddFamilyMemberViewController else { return }
            addFamilyMemberVC.choreTrackerController = choreTrackerController
            addFamilyMemberVC.childID = choreTrackerController.childID
        }
    }
}

extension FamilyHomeViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        familyMembersTableView.beginUpdates()
        }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        familyMembersTableView.endUpdates()
        }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            familyMembersTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            familyMembersTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            familyMembersTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            familyMembersTableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            familyMembersTableView.deleteRows(at: [oldIndexPath], with: .automatic)
            familyMembersTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            familyMembersTableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

