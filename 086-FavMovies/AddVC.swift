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
    
    var imdbURLString: String!
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Movie"
        
        imdbURLString = ""
        imagePicker = UIImagePickerController()
        
        descriptionTxt.delegate = self
        plotTxt.delegate = self
        imagePicker.delegate = self
        
        searchBtn.layer.cornerRadius = 5.0
        plotTxt.layer.cornerRadius = 5.0
        descriptionTxt.layer.cornerRadius = 5.0
    }
    
    override func viewWillAppear(animated: Bool) {
        urlTxt.text = imdbURLString
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        uploadImgBtn.hidden = true
        movieImg.image = image
    }
    
    
    @IBAction func onAddBtnPress(sender: AnyObject) {
        if let title = titleTxt.text where title != "" {
            let entity = NSEntityDescription.entityForName("Movie", inManagedObjectContext: managedObjectContext)!
            let movie = Movie(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
            movie.title = title
            movie.plot = plotTxt.text
            movie.myDesc = descriptionTxt.text
            movie.imdbUrl = urlTxt.text
            
            if movieImg.image != nil {
                movie.setMovieImg(movieImg.image!)
                managedObjectContext.insertObject(movie)
                do {
                    try managedObjectContext.save()
                } catch {
                    print("Could not save")
                }
                
                self.navigationController?.popViewControllerAnimated(true)

            } else {
                if presentedViewController != nil{
                    NSLog("Already showing alert")
                    return
                }
                
                let dialog = UIAlertController(title: "Missing Data", message: "Please add a picture.", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in }
                
                dialog.addAction(dismissAction)
                presentViewController(dialog, animated: true, completion: nil)
            }
        }
    }
    
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
