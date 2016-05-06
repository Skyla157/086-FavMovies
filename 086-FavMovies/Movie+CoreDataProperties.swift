//
//  Movie+CoreDataProperties.swift
//  086-FavMovies
//
//  Created by Meagan McDonald on 5/4/16.
//  Copyright © 2016 Skyla157. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Movie {

    @NSManaged var title: String?
    @NSManaged var image: NSData?
    @NSManaged var myDesc: String?
    @NSManaged var plot: String?
    @NSManaged var imdbUrl: String?

}
