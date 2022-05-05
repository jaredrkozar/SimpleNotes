//
//  NewNoteViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/19/21.
//

import UIKit
import WSTagsField

class NoteViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var noteTitleField: UITextField!
    @IBOutlet var noteDateField: UIDatePicker!
    @IBOutlet var noteTagsField: WSTagsField!
    @IBOutlet var drawingVIew: DrawingView!
    
    var timer: Timer?
    
    var isEditingNote: Bool = false
    
    var currentNote: Note?
    
    var textBoxes = [CustomTextBox]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        drawingVIew.tool = .highlighter
        drawingVIew.selectedBrush.width = 14.0
        
        noteTitleField.backgroundColor = UIColor.systemGray5
        noteTitleField.layer.cornerRadius = 6.0
        noteTitleField.text = currentNote?.title ?? ""
        
        noteTagsField.cornerRadius = 6.0
        noteTagsField.spaceBetweenTags = 3.0
        noteTagsField.numberOfLines = 2
        
        noteTagsField.readOnly = true
        noteTagsField.addTags((currentNote?.tags?.map({"\(String(describing: ($0 as AnyObject).name!))"})) ?? [String]())
        
        noteDateField.date = currentNote?.date ?? Date.now
  
        let saveNote = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNoteButtonTapped))
        
        let editTags = UIBarButtonItem(image: UIImage(systemName: "tag"), style: .plain, target: self, action: #selector(editTagsButtonTapped))
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        let shareButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "square.and.arrow.up"), primaryAction: nil, menu: shareButtonTapped())
        
        let flexibleSPace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let undoButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "arrow.uturn.backward"), primaryAction: nil, menu: shareButtonTapped())
        
        let redoButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "arrow.uturn.forward"), primaryAction: nil, menu: shareButtonTapped())
                                         
        
        let addMediaButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "plus"), primaryAction: nil, menu: shareButtonTapped())
        
        let highlighterTool = UIBarButtonItem(title: nil, image: UIImage(named: "Highlighter"), primaryAction: nil, menu: shareButtonTapped())
        
        let eraserTool = UIBarButtonItem(title: nil, image: UIImage(named: "Eraser"), primaryAction: nil, menu: shareButtonTapped())
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        
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
        saveNote(currentNote: nil, title: noteTitleField.text!, textboxes: textBoxes, date: noteDateField.date, tags: noteTagsField.tags.map({$0.text}))

        NotificationCenter.default.post(name: Notification.Name("UpdateNotesTable"), object: nil)
        
        dismiss(animated: true, completion: nil)
    }

    @objc func autoSaveNote() {
        saveNote(currentNote: currentNote, title: noteTitleField.text!, textboxes: textBoxes, date: noteDateField.date, tags: noteTagsField.tags.map({$0.text}))
    }
    
    
    @objc func editTagsButtonTapped(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editTagsVC") as! EditTagsTableViewController
        let navController = UINavigationController(rootViewController: vc)
        vc.newNoteVC = noteTagsField
        
        switch currentDevice {
        case .iphone:
            present(navController, animated: true, completion: nil)
        case .ipad, .mac:
            navController.modalPresentationStyle = UIModalPresentationStyle.popover
            navController.preferredContentSize = CGSize(width: 375, height: 300)
            navController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            present(navController, animated: true, completion: nil)
        case .none:
            return
        }
    }
    
    @objc func printLetter() {
        print("Fdkfkfkfkfkf")
    }
    
    func shareButtonTapped() -> UIMenu {

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shareNoteVC") as! NoteShareSettingsViewController
        let navigationController = UINavigationController(rootViewController: vc)
        
        var locations = [UIAction]()
        
        for location in SharingLocation.allCases {
            locations.append( UIAction(title: "\(location.viewTitle)", image: location.icon, identifier: nil, attributes: []) { _ in

                switch currentDevice {
                case .iphone:
                    if let picker = navigationController.presentationController as? UISheetPresentationController {
                       picker.detents = [.medium()]
                       picker.prefersGrabberVisible = true
                       picker.preferredCornerRadius = 7.0
                    }
                case .ipad, .mac:
                    navigationController.modalPresentationStyle = UIModalPresentationStyle.popover
                  navigationController.preferredContentSize = CGSize(width: 375, height: 300)
                    navigationController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
                    
                
                case .none:
                    return
                }
                
                vc.currentNoteView = self.drawingVIew
                vc.currentNote = self.currentNote
                vc.sharingLocation = location
                
                self.present(navigationController, animated: true, completion: nil)
             })
          }
        
        return UIMenu(title: "Share Note", subtitle: nil, image: nil, identifier: nil, options: [], children: locations)
        
    }
    
    @IBAction func penButton(_ sender: Any) {
        drawingVIew.tool = .pen
    }
    @IBAction func highlighter(_ sender: Any) {
        drawingVIew.tool = .highlighter
        drawingVIew.selectedBrush.color = .systemRed
    }
}
