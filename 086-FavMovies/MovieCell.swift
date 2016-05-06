//
//  MovieCell.swift
//  086-FavMovies
//
//  Created by Meagan McDonald on 5/4/16.
//  Copyright © 2016 Skyla157. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var decriptionLbl: UILabel!
    @IBOutlet weak var urlLbl: UILabel!
    @IBOutlet weak var bgImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        posterImg.clipsToBounds = true
        posterImg.layer.cornerRadius = 4.0
        
    }
    
    func configureCell(movie: Movie) {
        posterImg.image = movie.getMovieImg()
        titleLbl.text = movie.title
        decriptionLbl.text = movie.myDesc
        urlLbl.text = movie.imdbUrl
        bgImg.image = movie.getMovieImg()
    }



}
