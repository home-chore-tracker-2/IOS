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
        if choreTrackerController.isUserLoggedIn == false {
            performSegue(withIdentifier: "SignUpOrInSegue", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func addChoresButtonTapped(_ sender: Any) {

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
//        cell.childNameLabel.text = child.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Children"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let child = fetchedResultsController.object(at: indexPath)
            choreTrackerController.deleteChild(child: child)
        }
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpOrInSegue" {
            guard let signUpOrInVC = segue.destination as? RegisterAndLoginViewController else { return }
            signUpOrInVC.choreTrackerController = choreTrackerController
        } else if segue.identifier == "AddFamilyMemberSegue" {
            guard let addFamilyMemberVC = segue.destination as? AddFamilyMemberViewController else { return }
            addFamilyMemberVC.choreTrackerController = choreTrackerController
            addFamilyMemberVC.childID = choreTrackerController.childID
        } else if segue.identifier == "ChildDetailSegue" {
            guard
                let childDetailVC = segue.destination as? ChildDetailViewController,
                let indexPath = familyMembersTableView.indexPathForSelectedRow
                else { return }
            let child = fetchedResultsController.object(at: indexPath)
            childDetailVC.choreTrackerController = choreTrackerController
            childDetailVC.child = child
            
            
        } else if segue.identifier == "AddChoreSegue" {
            guard let addChoreVC = segue.destination as? AddChoreViewController else { return }
            addChoreVC.choreTrackerController = choreTrackerController
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

