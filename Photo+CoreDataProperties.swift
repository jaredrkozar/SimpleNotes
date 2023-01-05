//
//  Photo+CoreDataProperties.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/3/23.
//
//

import Foundation
import CoreData

extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var image: Data?
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var height: Double
    @NSManaged public var width: Double
    @NSManaged public var note: Note?

}

extension Photo : Identifiable {

}
