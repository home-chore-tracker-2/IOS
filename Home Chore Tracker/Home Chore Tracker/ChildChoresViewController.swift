//
//  ChildChoresViewController.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/6/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import UIKit
import CoreData

class ChildChoresViewController: UIViewController, UITableViewDataSource {
    
    var choreTrackerController: ChoreTrackerController? {
        didSet {
            
        }
    }
    var selectedChore: ChoreRepresentation?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Chore> = {
        let fetchRequest: NSFetchRequest<Chore> = Chore.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "choreName", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "choreName", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    @IBOutlet weak var childChoresTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        choreTrackerController?.fetchChores()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childChoresTableView.dataSource = self
        choreTrackerController?.fetchChores()
//        Chore(id: 1, points: 10, bonusPoints: 0, choreName: "Clean Room", description: "Pick up dirty clothes, make the bed, and take out the trash.", dueDate: Date(), picture: URL(string: ""), completed: false)
//        choreTrackerController?.saveToPersistentStore()
    }
    
    
    
    
    // MARK: Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = childChoresTableView.dequeueReusableCell(withIdentifier: "ChoreCell", for: indexPath) as? ChildChoreTableViewCell else { return UITableViewCell()}
        
        let chore = fetchedResultsController.object(at: indexPath)
        selectedChore = ChoreRepresentation(id: Int(chore.id), points: Int(chore.points), bonusPoints: Int(chore.bonusPoints), choreName: chore.choreName ?? "New Chore", description: chore.choreDescription ?? "", dueDate: chore.dueDate ?? Date(), picture: nil, completed: chore.completed)
        cell.chore = chore
        cell.choreNameLabel.text = chore.choreName
        return cell
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChoreDetailModalSegue" {
            guard let destinationVC = segue.destination as? MarkChoreCompleteViewController else { return }
            destinationVC.assignedChore = self.selectedChore
            destinationVC.choreTrackerController = self.choreTrackerController
        }
    }
    

}

extension ChildChoresViewController: NSFetchedResultsControllerDelegate {
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
