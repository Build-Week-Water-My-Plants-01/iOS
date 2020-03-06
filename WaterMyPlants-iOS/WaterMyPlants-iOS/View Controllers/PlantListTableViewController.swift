//
//  PlantListTableViewController.swift
//  WaterMyPlants-iOS
//
//  Created by Austin Potts on 3/2/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreData




class PlantListTableViewController: UITableViewController {
   
    

    let userController = UserController()
    let plantController = PlantController()
    
   
    @IBAction func unwindToTable(_ sender: UIStoryboardSegue){
              
          }
   
    
    @IBAction func waterButtonTapped(_ sender: Any) {
        timerCountdownStart()
    }
    
    //MARK: - TIMER
    func timerCountdownStart(){
            
           var frequencyCount = 0
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                frequencyCount += 1
                print(frequencyCount)
                
                if frequencyCount == 5 {
                    self.showAlert()
                   
                    
                            timer.invalidate()
                         }
            }
        
          
            
            timer.fire()
        
    }

    
    //MARK: - ALERT
    func showAlert(){
        
        
        
    let alert = UIAlertController(title: "Time to water your plant!", message: "Your plant is dad", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
        
    }
    
    
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Plant> = {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nickname", ascending: true)]
    
        
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "nickname",
                                             cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch:\(error)")
        }
        
        return frc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
       // fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nickname", ascending: true)]
        
        let context = CoreDataStack.shared.mainContext
        
        let results = try? context.fetch(fetchRequest)
        
        print(results)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        plantController.userController = userController
        
         if let bearer = userController.bearer {
            plantController.fetchPlantsFromServer(bearer: bearer)
         } else  {
             performSegue(withIdentifier: "LogInSegue", sender: self)
         }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as? PlantTableViewCell else { return UITableViewCell() }

        let plant = fetchedResultsController.object(at: indexPath)
        cell.plant = plant

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        return sectionInfo.name.capitalized
    }
    
 

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        guard editingStyle == .delete else { return }
        let plant = fetchedResultsController.object(at: indexPath)
        plantController.delete(plant: plant)
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "AddPlantSegue" {
            if let detailVC = segue.destination as? PlantDetailViewController {
                detailVC.usercontroller = userController
                detailVC.plantController = plantController
            }
            
        } else if segue.identifier == "LogInSegue" {
                if let logInDetailVC = segue.destination as? LoginViewController {
                    logInDetailVC.userController = userController
                }
            }
    }
    
    

}

extension PlantListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let sectionSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(sectionSet, with: .automatic)
        case .delete:
            tableView.deleteSections(sectionSet, with: .automatic)
        default:
            return
        }
    }
}
