//
//  DetailsVC.swift
//  086-FavMovies
//
//  Created by Meagan McDonald on 5/4/16.
//  Copyright © 2016 Skyla157. All rights reserved.
//

import UIKit
import CoreData

class DetailsVC: UIViewController {

    @IBOutlet weak var myDesc: UITextView!
    @IBOutlet weak var plot: UITextView!
    @IBOutlet weak var imdbLink: UIButton!
    @IBOutlet weak var movieImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = DataService.instance.movieDetail.title
        
        myDesc.text = DataService.instance.movieDetail.myDesc
        plot.text = DataService.instance.movieDetail.plot
        imdbLink.setTitle(DataService.instance.movieDetail.imdbUrl, forState: .Normal)
        movieImg.image = DataService.instance.movieDetail.getMovieImg()
    }
    
    @IBAction func onLinkPress(sender: AnyObject) {
        if let targetURL = NSURL(string: DataService.instance.movieDetail.imdbUrl!) {
            let isAvailable = UIApplication.sharedApplication().canOpenURL(targetURL)
            if isAvailable {
                UIApplication.sharedApplication().openURL(targetURL)
            } else {
                NSLog("Can't use Safari");
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditMovie" {
            DataService.instance.isEditing = true
        }
    }
}
