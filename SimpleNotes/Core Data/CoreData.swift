//
//  CoreData.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/23/21.
//

import UIKit
import CoreData

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func saveTag(name: String, symbol: String, color: String) {
  
    let newTag = AllTags(context: context)
    newTag.symbol = symbol
    newTag.name = name
    newTag.color = color
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

func saveNote(currentNote: Note?, title: String, text: String, date: Date, tags: [String]) {
   
    let newNote = currentNote ?? Note(context: context)

    newNote.title = title
    newNote.text = text
    newNote.date = date
    
    var tagset = Set<Tags>()
    
    for tag in tags {
        let newtag = Tags(context: context)
        newtag.name = tag
        newtag.notes = newNote
        tagset.insert(newtag)
    }

    newNote.addToTags(tagset)
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
}

func fetchNotes(tag: String?) {
    let request = Note.fetchRequest() as NSFetchRequest<Note>
    
    if tag != nil {
        request.predicate = NSPredicate(format:  "tags.name CONTAINS[c] %@", tag!)
    }

    do {
        
        notes = try context.fetch(request)
    } catch {
        print("Fetch failed")
    }
}

func deleteNote(note: Note) {
    context.delete(note)
    do {
        try context.save()
    } catch {
        print("An error occured")
    }
}

func deleteTag(tag: AllTags) {
    context.delete(tag)
    
    do {
        try context.save()
    } catch {
        print("An error occured")
    }
}
