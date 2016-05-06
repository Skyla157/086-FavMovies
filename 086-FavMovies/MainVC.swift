//
//  ViewController.swift
//  086-FavMovies
//
//  Created by Meagan McDonald on 5/4/16.
//  Copyright © 2016 Skyla157. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editRowsBtn: UIBarButtonItem!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setNavigationBarColorAndStyle()
        
        do {
            try fetchedResultsController.performFetch()
        } catch let err as NSError {
            print(err.debugDescription)
        }

        self.tableView.editing = false
        self.editRowsBtn.title = "Edit"
        
        //clearCoreData()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        DataService.instance.isEditing = false
    }
    
    // MARK: -
    // MARK: Table View Set Up
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    // MARK: Editing
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let movie = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
            managedObjectContext.deleteObject(movie)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: -
    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! MovieCell
                configureCell(cell, atIndexPath: indexPath)
            }
            break;
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
    
    // MARK: -
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetails" {
            if let selectedCell = sender as? MovieCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let selectedMovie = fetchedResultsController.objectAtIndexPath(indexPath) as! Movie
                DataService.instance.movieDetail = selectedMovie
                DataService.instance.oldMovieIndex = indexPath.row
            }
        }
    }
    
    //MARK: -
    //MARK: Styling
    func setNavigationBarColorAndStyle() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 59.0/255, green: 165.0/255, blue: 162/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "logo.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func configureCell(cell: MovieCell, atIndexPath indexPath: NSIndexPath) {
        let movie = fetchedResultsController.objectAtIndexPath(indexPath) as! Movie
        
        cell.titleLbl.text = movie.title
        cell.decriptionLbl.text = movie.myDesc
        cell.urlLbl.text = movie.imdbUrl
        cell.bgImg.image = movie.getMovieImg()
        cell.posterImg.image = movie.getMovieImg()
        cell.bgImg.clipsToBounds = true
    }
    
    func clearCoreData() {
        let entityDescription = NSEntityDescription.entityForName("Movie", inManagedObjectContext: managedObjectContext)

        let request = NSFetchRequest()
        request.entity = entityDescription

        request.includesPropertyValues = false
        do {
            if let results = try managedObjectContext.executeFetchRequest(request) as? [NSManagedObject] {
                for result in results {
                    managedObjectContext.deleteObject(result)
                }
                try managedObjectContext.save()
            }
        } catch {
            NSLog("failed to clear core data")
        }
    }
    
    @IBAction func isEditing(sender: UIBarButtonItem) {
        if !self.tableView.editing {
            self.editRowsBtn.title = "Done"
            self.tableView.editing = true
        } else {
            self.editRowsBtn.title = "Edit"
            self.tableView.editing = false
        }
    }
}

