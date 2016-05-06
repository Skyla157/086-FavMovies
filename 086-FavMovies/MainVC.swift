//
//  ViewController.swift
//  086-FavMovies
//
//  Created by Meagan McDonald on 5/4/16.
//  Copyright © 2016 Skyla157. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.leftBarButtonItem = editButtonItem()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 59.0/255, green: 165.0/255, blue: 162/255.0, alpha: 1)

        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
//        let entityDescription = NSEntityDescription.entityForName("Movie", inManagedObjectContext: managedObjectContext)
//        
//        let request = NSFetchRequest()
//        request.entity = entityDescription
//        
//        request.includesPropertyValues = false
//        do {
//            if let results = try managedObjectContext.executeFetchRequest(request) as? [NSManagedObject] {
//                for result in results {
//                    managedObjectContext.deleteObject(result)
//                }
//                try managedObjectContext.save()
//            }
//        } catch {
//            NSLog("failed to clear core data")
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchAndSetResults()
        tableView.reloadData()
    }
    
    func fetchAndSetResults() {
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            movies = results as! [Movie]
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as? MovieCell {
            let movie = movies[indexPath.row]
            cell.configureCell(movie)
            return cell
        } else {
            return MovieCell()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // MARK: Move Cells
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let movie = movies[sourceIndexPath.row]
        movies.removeAtIndex(sourceIndexPath.row)
        movies.insert(movie, atIndex: destinationIndexPath.row)
    }
    
    // MARK: Editing
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            managedObjectContext.deleteObject(movies[indexPath.row] as NSManagedObject)
            movies.removeAtIndex(indexPath.row)
            do {
                try managedObjectContext.save()
            } catch let error as NSError  {
                NSLog("Could not save \(error), \(error.userInfo)")
            }
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
        default: return
        }
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetails" {
            let destination = segue.destinationViewController as! DetailsVC
            if let selectedCell = sender as? MovieCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let selectedMovie = movies[indexPath.row]
                destination.movieDetail = selectedMovie
            }
        }
    }
}

