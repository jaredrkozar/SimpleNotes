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
    
    var timer: Timer?
    
    var isEditingNote: Bool = false
    
    var currentNote: Note?
    
    var viewDelegate: RefreshDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        noteTitleField.backgroundColor = UIColor.systemGray5
        noteTitleField.layer.cornerRadius = 6.0
        noteTitleField.text = currentNote?.title ?? ""
        
        noteTextField.backgroundColor = UIColor.systemGray5
        noteTextField.layer.cornerRadius = 6.0
        noteTextField.text = currentNote?.text ?? ""
        
        noteTagsField.cornerRadius = 6.0
        noteTagsField.spaceBetweenTags = 3.0
        noteTagsField.numberOfLines = 2
        noteTagsField.addTags(currentNote?.tags ?? [])
        noteTagsField.readOnly = true
        
        noteDateField.date = currentNote?.date ?? Date.now
  
        let saveNote = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNoteButtonTapped))
        
        let editTags = UIBarButtonItem(image: UIImage(systemName: "tag"), style: .plain, target: self, action: #selector(editTagsButtonTapped))
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        
        if isEditingNote == true {
            title = "Edit Note"
            self.navigationItem.rightBarButtonItems = [shareButton, editTags]
            timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(autoSaveNote), userInfo: nil, repeats: true)
        } else {
            title = "New Note"
            self.navigationItem.leftBarButtonItems = [cancel]
            self.navigationItem.rightBarButtonItems = [saveNote, editTags]
        }
    }
    
    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveNoteButtonTapped(sender: UIBarButtonItem) {
        saveNote(currentNote: nil, title: noteTitleField.text!, text: noteTextField.text, date: noteDateField.date, tags: noteTagsField.tags.map({$0.text}))

        NotificationCenter.default.post(name: Notification.Name("UpdateNotesTable"), object: nil)
        
        dismiss(animated: true, completion: nil)
    }

    @objc func autoSaveNote() {
        saveNote(currentNote: currentNote, title: noteTitleField.text!, text: noteTextField.text, date: noteDateField.date, tags: noteTagsField.tags.map({$0.text}))
    }
    
    
    @objc func editTagsButtonTapped(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editTagsVC") as! EditTagsTableViewController
        let navController = UINavigationController(rootViewController: vc)
        vc.newNoteVC = noteTagsField
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc func shareButtonTapped(sender: UIBarButtonItem) {
        print("Share")
    }
    
}
