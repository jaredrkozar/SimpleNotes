//
//  Tag+CoreDataProperties.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/21/21.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var symbol: String?
    @NSManaged public var name: String?

}

extension Tag : Identifiable {

}
