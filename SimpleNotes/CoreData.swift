//
//  CoreData.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/23/21.
//

import UIKit
import CoreData

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func saveTag(name: String, symbol: String) {
  
    let newTag = Tag(context: context)
    newTag.symbol = symbol
    newTag.name = name
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a tag.")
    }
}

func fetchTags() {
    do {
        tags = try context.fetch(Tag.fetchRequest())
    } catch {
        print("An error occured")
    }
}
