//
//  AllTags+CoreDataProperties.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/24/22.
//
//

import Foundation
import CoreData


extension AllTags {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllTags> {
        return NSFetchRequest<AllTags>(entityName: "AllTags")
    }

    @NSManaged public var name: String?
    @NSManaged public var symbol: String?

}

extension AllTags : Identifiable {

}
