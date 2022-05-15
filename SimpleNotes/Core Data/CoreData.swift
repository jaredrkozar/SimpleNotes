//
//  CoreData.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/23/21.
//

import UIKit
import CoreData

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func saveTag(currentTag: AllTags?, name: String, symbol: String, color: String) {
  
    let newTag = currentTag ?? AllTags(context: context)
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

func createNote() -> Note {
    let newNote = Note(context: context)
    newNote.date = Date()
    newNote.title = ""
    newNote.tags = []
    newNote.isLocked = false
    return newNote
}

func saveNote(currentNote: Note?, title: String, textboxes: [CustomTextBox], date: Date, tags: [String], isLocked: Bool) {
   
    let newNote = currentNote ?? Note(context: context)

    newNote.title = title
    newNote.date = date
    newNote.noteID = UUID().uuidString
    newNote.isLocked = isLocked
    var tagset = Set<Tags>()
    
    for tag in tags {
        let newtag = Tags(context: context)
        newtag.name = tag
        newtag.notes = newNote
        tagset.insert(newtag)
    }

    newNote.addToTags(tagset)
    
    var textboxes = Set<TextBox>()
    
    for textbox in textboxes {
        let newtextbox = TextBox(context: context)
        newtextbox.text = textbox.text
        newtextbox.xCoordinate = textbox.xCoordinate
        newtextbox.yCoordinate = textbox.yCoordinate
    }

    newNote.addToTextbox(textboxes)
    
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
