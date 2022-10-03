//
//  Image+CoreDataProperties.swift
//  SimpleNotes
//
//  Created by JaredKozar on 7/25/22.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var image: Data?
    @NSManaged public var note: Note?

}

extension Image : Identifiable {

}
