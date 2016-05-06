//
//  AddVC.swift
//  086-FavMovies
//
//  Created by Meagan McDonald on 5/4/16.
//  Copyright © 2016 Skyla157. All rights reserved.
//

import UIKit
import CoreData
import WebKit

class AddVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var plotTxt: UITextView!
    @IBOutlet weak var urlTxt: UITextField!
    @IBOutlet weak var myDescPlaceholderLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var uploadImgBtn: UIButton!
    @IBOutlet weak var plotPlaceholderLbl: UILabel!
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var imdbURLString: String!
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imdbURLString = ""
        imagePicker = UIImagePickerController()
        
        descriptionTxt.delegate = self
        plotTxt.delegate = self
        imagePicker.delegate = self
        
        searchBtn.layer.cornerRadius = 5.0
        plotTxt.layer.cornerRadius = 5.0
        descriptionTxt.layer.cornerRadius = 5.0
        
        if DataService.instance.isEditing {
            titleTxt.text = DataService.instance.movieDetail!.title
            descriptionTxt.text = DataService.instance.movieDetail!.myDesc
            plotTxt.text = DataService.instance.movieDetail!.plot
            imdbURLString = DataService.instance.movieDetail!.imdbUrl
            movieImg.image = DataService.instance.movieDetail!.getMovieImg()
            myDescPlaceholderLbl.hidden = true
            plotPlaceholderLbl.hidden = true
            navigationItem.title = "Edit Movie"
            saveBtn.setTitle("Save Changes", forState: .Normal)
            
        } else {
            navigationItem.title = "Add Movie"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        urlTxt.text = imdbURLString
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        uploadImgBtn.hidden = true
        movieImg.image = image
    }
    
    @IBAction func onSaveBtnPress(sender: AnyObject) {
        if titleTxt.text != nil && movieImg.image != nil  {
            
            if DataService.instance.isEditing {
                managedObjectContext.deleteObject(DataService.instance.movieDetail as NSManagedObject)

                do {
                    try managedObjectContext.save()
                } catch let error as NSError  {
                    NSLog("Could not save \(error), \(error.userInfo)")
                }
            }

            let entity = NSEntityDescription.entityForName("Movie", inManagedObjectContext: managedObjectContext)!
            let movie = Movie(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
            movie.title = titleTxt.text
            movie.plot = plotTxt.text
            movie.myDesc = descriptionTxt.text
            movie.imdbUrl = urlTxt.text
            
            movie.setMovieImg(movieImg.image!)
            managedObjectContext.insertObject(movie)
            do {
                try managedObjectContext.save()
            } catch {
                print("Could not save")
            }
            if DataService.instance.isEditing {
                self.navigationController?.popToRootViewControllerAnimated(true)
            } else {
                self.navigationController?.popViewControllerAnimated(true)
            }

        } else {
            if presentedViewController != nil {
                NSLog("Already showing alert")
                return
            }
            
            let dialog = UIAlertController(title: "Missing Data", message: "Missing image or movie title. Please add.", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in }
            
            dialog.addAction(dismissAction)
            presentViewController(dialog, animated: true, completion: nil)
        }
    }
    
    //hides placeholder text when view is being edited
    func textViewDidBeginEditing(textView: UITextView) {
        switch (textView) {
        case plotTxt: plotPlaceholderLbl.hidden = true
        case descriptionTxt: myDescPlaceholderLbl.hidden = true
        default: return
        }
    }
    
    @IBAction func onUploadImgPress(sender: AnyObject) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "OpenIMDB" {
            if let destination = segue.destinationViewController as? IMDBSearchVC {
                if urlTxt.text == "" {
                    destination.movieTitle = titleTxt.text!
                } else {
                    destination.movieTitle = urlTxt.text
                }
            }
        }
    }
    
    @IBAction func unwindToAddList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? IMDBSearchVC {
            if imdbURLString == "" || imdbURLString != sourceViewController.imdbURLString {
                imdbURLString = sourceViewController.imdbURLString
            }
        }
    }
    
}
