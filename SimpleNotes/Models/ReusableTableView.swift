//
//  ReusableDocumentsTableView.swift
//  VisionText
//
//  Created by JaredKozar on 12/16/21.
//

import UIKit
import WSTagsField

class ReusableTableView: NSObject, UITableViewDataSource {

    var note = [Note]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell else {
            fatalError("Unable to dequeue the image cell.")
        }
        
        let note = note[indexPath.row]

        cell.noteTitle.text = note.title

        cell.noteText.text = note.text
        cell.noteDate.text = note.date!.formatted()
        
        cell.noteTags.addTag("DD")
       
        cell.accessibilityLabel = "\(note.title) Created on \(note.date)"
        
        cell.layoutIfNeeded()
        return cell
    }
    
}
