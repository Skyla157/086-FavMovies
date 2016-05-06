//
//  DataService.swift
//  086-FavMovies
//
//  Created by Meagan McDonald on 5/4/16.
//  Copyright © 2016 Skyla157. All rights reserved.
//

import Foundation
import UIKit

class DataService {
    static let instance = DataService()
    
    private var _loadedMovies = [Movie]()
    var loadedMovies: [Movie] {
        return _loadedMovies
    }
    
    
}