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
  
    let newTag = AllTags(context: context)
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
        tags = try context.fetch(AllTags.fetchRequest())
    } catch {
        print("An error occured")
    }
}

func saveNote(title: String, text: String, date: Date, tags: [String]) {
  
    let newNote = Note(context: context)
    newNote.title = title
    newNote.text = text
    newNote.date = date
    newNote.tags = tags

    do {
        try context.save()
    } catch {
        print("An error occured while saving a tag.")
    }
}

func fetchNotes() {
    do {
        notes = try context.fetch(Note.fetchRequest())
    } catch {
        print("An error occured")
    }
}
