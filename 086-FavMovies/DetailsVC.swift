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

//    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var myDesc: UITextView!
    @IBOutlet weak var plot: UITextView!
    @IBOutlet weak var imdbLink: UIButton!
    @IBOutlet weak var movieImg: UIImageView!
    
    var movieDetail: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = movieDetail.title
        
        myDesc.text = movieDetail.myDesc
        plot.text = movieDetail.plot
        imdbLink.setTitle(movieDetail.imdbUrl, forState: .Normal)
        movieImg.image = movieDetail.getMovieImg()
    }
    
    @IBAction func onLinkPress(sender: AnyObject) {
        
        if let targetURL = NSURL(string: movieDetail.imdbUrl!) {
            let isAvailable = UIApplication.sharedApplication().canOpenURL(targetURL)
            if isAvailable {
                UIApplication.sharedApplication().openURL(targetURL)
            } else {
                NSLog("Can't use Safari");
            }
        }
    }
}
