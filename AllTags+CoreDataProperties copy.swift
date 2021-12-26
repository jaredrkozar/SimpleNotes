//
//  AllTags+CoreDataProperties.swift
//  
//
//  Created by JaredKozar on 12/26/21.
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
