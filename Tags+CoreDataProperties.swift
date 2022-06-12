//
//  Tags+CoreDataProperties.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/24/22.
//
//

import Foundation
import CoreData


extension Tags {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tags> {
        return NSFetchRequest<Tags>(entityName: "Tags")
    }

    @NSManaged public var name: String?
    @NSManaged public var notes: Note?

}

extension Tags : Identifiable {
    func configured(name: String,
                    note: Note) -> Self {
        return self
      }
}
