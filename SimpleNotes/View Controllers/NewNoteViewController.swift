//
//  NewNoteViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/19/21.
//

import UIKit
import WSTagsField

class NewNoteViewController: UIViewController {

    @IBOutlet var noteTitleField: UITextField!
    @IBOutlet var noteDateField: UIDatePicker!
    @IBOutlet var noteTextField: UITextView!
    @IBOutlet var noteTagsField: WSTagsField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "New Note"
        
        noteTitleField.backgroundColor = UIColor.systemGray5
        noteTitleField.layer.cornerRadius = 6.0
        
        noteTextField.backgroundColor = UIColor.systemGray5
        noteTextField.layer.cornerRadius = 6.0
        
        noteTagsField.cornerRadius = 6.0
        noteTagsField.spaceBetweenTags = 3.0
        noteTagsField.numberOfLines = 2

        let saveNote = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNoteButtonTapped))
        
        let editTags = UIBarButtonItem(image: UIImage(systemName: "tag"), style: .plain, target: self, action: #selector(editTagsButtonTapped))
        
        self.navigationItem.rightBarButtonItems = [editTags, saveNote]
    }
    
    @objc func saveNoteButtonTapped(sender: UIBarButtonItem) {
        saveNote(title: noteTitleField.text!, text: noteTextField.text, date: noteDateField.date, tags: noteTagsField.tags.map({$0.text}))
        dismiss(animated: true, completion: nil)
    }

    @objc func editTagsButtonTapped(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editTagsVC") as! EditTagsTableViewController
        let navController = UINavigationController(rootViewController: vc)
        vc.newNoteVC = noteTagsField
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
}
