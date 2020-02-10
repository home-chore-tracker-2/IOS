//
//  ChildDetailViewController.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/8/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import UIKit
import CoreData

class ChildDetailViewController: UIViewController, UITableViewDataSource {
    
    var choreTrackerController: ChoreTrackerController? {
        didSet {
            
        }
    }
    
    var child: Child? {
        didSet {
            
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Chore> = {
        let fetchRequest: NSFetchRequest<Chore> = Chore.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "choreName", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "choreName", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var choreScoreLabel: UILabel!
    @IBOutlet weak var cleanStreakLabel: UILabel!
    @IBOutlet weak var childChoresTableView: UITableView!
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childChoresTableView.dataSource = self
        updateViews()
    }
    
    @IBAction func addChoreButtonTapped(_ sender: Any) {
    }
    
    
    
    // MARK: - Table View Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = childChoresTableView.dequeueReusableCell(withIdentifier: "ChoreDetail", for: indexPath) as? ChildDetailTableViewCell else { return UITableViewCell()}

        let chore = fetchedResultsController.object(at: indexPath)
        cell.chore = chore
        if cell.chore?.completed == false {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        cell.choreNameLabel.text = chore.choreName
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Chores"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let chore = fetchedResultsController.object(at: indexPath)
            choreTrackerController?.deleteChore(chore: chore)
        }
    }
    
    func updateViews() {
        guard
            let child = child,
            let allChores = fetchedResultsController.fetchedObjects
            else { return }
        childNameLabel.text = child.username
        
//        let chore = fetchedResultsController.object(at: indexPath)
        var totalPoints: Int64 = 0
        for chore in allChores {
            if chore.completed {
                totalPoints += chore.points + chore.bonusPoints
                    print(child.points)
                }
        }
        
        child.points = totalPoints
        
        choreScoreLabel.text = "\(child.points)"
    }
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddChoreSegue" {
            guard let addChoreVC = segue.destination as? AddChoreViewController else { return }
            addChoreVC.choreTrackerController = choreTrackerController
        } else if segue.identifier == "ChoreDetailSegue" {
            guard let choreDetailVC = segue.destination as? ChoreDetailViewController, let indexPath = childChoresTableView.indexPathForSelectedRow
                else { return }
            choreDetailVC.choreTrackerController = choreTrackerController
            let chore = fetchedResultsController.object(at: indexPath)
            choreDetailVC.chore = chore
            choreDetailVC.child = child
        }
    }
}

extension ChildDetailViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        childChoresTableView.beginUpdates()
        }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        childChoresTableView.endUpdates()
        }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            childChoresTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            childChoresTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            childChoresTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            childChoresTableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            childChoresTableView.deleteRows(at: [oldIndexPath], with: .automatic)
            childChoresTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            childChoresTableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
