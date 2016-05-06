//
//  File.swift
//  086a-FavMovies
//
//  Created by Meagan McDonald on 5/6/16.
//  Copyright © 2016 Skyla157. All rights reserved.
//

import Foundation
import UIKit

class DataService {
    
    static let instance = DataService()
    
    var movieDetail: Movie!
    
    var isEditing: Bool = false
    
    var oldMovieIndex: Int!
}
