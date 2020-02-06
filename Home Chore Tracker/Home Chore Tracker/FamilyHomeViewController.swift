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
    
    lazy var fetchedResultsController: NSFetchedResultsController<Parent> = {
        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "username", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    @IBOutlet weak var familyMembersTableView: UITableView!
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        familyMembersTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if choreTrackerController.isUserLoggedIn == false {
            performSegue(withIdentifier: "SignUpOrInModalSegue", sender: self)
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = familyMembersTableView.dequeueReusableCell(withIdentifier: "FamilyMemberCell", for: indexPath) as? FamilyMemberTableViewCell else { return UITableViewCell()}
        
        let user = fetchedResultsController.object(at: indexPath)
        cell.user = user
        cell.familyMemberNameLabel.text = user.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Parent"
        case 1:
            if familyMembersTableView.numberOfRows(inSection: 1) <= 1 {
                return "Child"
            } else {
                return "Children"
            }
        default:
            return ""
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

