//
//  TextBox+CoreDataProperties.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/28/22.
//
//

import Foundation
import CoreData


extension TextBox {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextBox> {
        return NSFetchRequest<TextBox>(entityName: "TextBox")
    }

    @NSManaged public var xCoordinate: Float
    @NSManaged public var yCoordinate: Float
    @NSManaged public var text: String?
    @NSManaged public var note: Note?

}

extension TextBox : Identifiable {

}
