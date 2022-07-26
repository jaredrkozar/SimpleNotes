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
    newNote.title = "New Note"
    newNote.tags = []
    newNote.isLocked = false
    newNote.noteID = UUID().uuidString
    return newNote
}

func saveStrokes(strokes: [UIBezierPath], note: Note) {
   
}

func saveTextBoxes(textBoxes: [UITextField], note: Note) {
    var textboxesset = Set<TextBox>()
    
    for textBox in textboxesset {
        let newTextbox = TextBox(context: context)
        textboxesset.insert(newTextbox)
    }
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
}

func saveImages(images: [UIImage], note: Note) {
    var imageset = Set<Image>()
    
    for image in images {
        let newImage = Image(context: context)
        let imageAsData = image.jpegData(compressionQuality: 1.0)
        newImage.image = imageAsData
        imageset.insert(newImage)
    }
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
}

func saveTitle(title: String, note: Note) {
    note.setValue(title, forKey: "title")
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
}

func saveDate(date: Date, note: Note) {
    note.setValue(date, forKey: "date")
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
}

func saveAll(note: Note, date: Date, title: String, textBoxes: [UITextView], strokes: [Line], images: [UIImage]) {
    note.setValue(date, forKey: "date")
    note.setValue(title, forKey: "title")
    
    var imageset = Set<Image>()
    
    for image in images {
        let newImage = Image(context: context)
        let imageAsData = image.jpegData(compressionQuality: 1.0)
        newImage.image = imageAsData
        imageset.insert(newImage)
    }
    
    var textBoxes = Set<TextBox>()
    
    for textBox in textBoxes {
        textBoxes.insert(textBox)
    }
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
}

func saveTagsForNote(tags: [String], note: Note) {
    var tagset = Set<Tags>()
    
    for tag in tags {
        let newtag = Tags(context: context)
        newtag.name = tag
        newtag.notes = note
        tagset.insert(newtag)
    }
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
    
}

func fetchNotes(tag: String?, sortOption: sortOptions?) {
    let request = Note.fetchRequest() as NSFetchRequest<Note>
    let sort = NSSortDescriptor(key: sortOption?.sortType, ascending: sortOption!.ascending)
    request.sortDescriptors = [sort]
    
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
