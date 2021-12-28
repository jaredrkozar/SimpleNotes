//
//  Note+CoreDataProperties.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/28/21.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: Date?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var tags: [String]?

}

extension Note : Identifiable {

}
