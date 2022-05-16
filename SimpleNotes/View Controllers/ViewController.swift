//
//  ViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/8/21.
//

import UIKit

class ViewController: UITableViewController, UINavigationControllerDelegate {
    
    var dataSource = ReusableTableView()
    
    func viewAppeared(currentTag: String?) {
        fetchNotes(tag: currentTag)
        
        tableView.dataSource = dataSource
        dataSource.listofnotes = notes
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentDevice == .iphone || self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact {
            viewAppeared(currentTag: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "NoteTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NoteTableViewCell")
        
        tableView.rowHeight = 180
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addNote = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addNote))
        
        let settings = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsScreen))

        self.navigationItem.rightBarButtonItems = [addNote, settings]
        
    }
    
    @objc func addNote(sender: UIBarButtonItem) {
  
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newNoteVC") as! NoteViewController
        
        vc.currentNote = createNote()
        vc.isNoteLocked = false
        
        switch currentDevice {
        case .ipad, .mac:
                splitViewController?.setViewController(vc, for: .secondary)
            
            showDetailViewController(vc, sender: true)
        case .iphone:
                navigationController?.pushViewController(vc, animated: true)
        case .none:
            return
        }
    }

    @objc func settingsScreen(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
        let navController = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource.listofnotes[indexPath.row].isLocked == true {
           
            LockNote().authenticate(title: "View this note", onCompleted: {result, error in
                if error == nil {
                    self.showNote(note: self.dataSource.listofnotes[indexPath.row])
                } else {
                    CustomAlert.showAlert(title: "Face ID Error", message: error.debugDescription)
                }
            })
            
        } else {
            showNote(note: self.dataSource.listofnotes[indexPath.row])
        }
        
       
    }
    
    func showNote(note: Note) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newNoteVC") as! NoteViewController
        
        vc.currentNote = note
        vc.isNoteLocked = note.isLocked
        
        switch currentDevice {
        case .ipad, .mac:
            self.splitViewController?.setViewController(vc, for: .secondary)
            
            self.showDetailViewController(vc, sender: true)
        case .iphone:
            self.navigationController?.pushViewController(vc, animated: true)
        case .none:
            return
        }
    }
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(
              title: "Edit Tags", image: UIImage(systemName: "tag")) { [self] _ in
                //gets the current dimension and splits it up into 2 parts, and saves them so they can be shown in the text fields in editPresetViewController. The editPresetViewController is then shown via a popover
                
                  let cellTag = tableView.cellForRow(at: indexPath) as! NoteTableViewCell
                  
                  let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editTagsVC") as! EditTagsTableViewController
                  let navController = UINavigationController(rootViewController: vc)
                  vc.newNoteVC = cellTag.noteTags
                  self.navigationController?.present(navController, animated: true, completion: nil)
                
            }
            
            let deleteAction = UIAction(
                //deletes the current cell
              title: "Delete",
              image: UIImage(systemName: "trash"),
                attributes: .destructive) { [self] _ in
                    
                    if dataSource.listofnotes[indexPath.row].isLocked == true {
                        LockNote().authenticate(title: "Delete this note", onCompleted: {result, error in
                            if error == nil {
                                deleteNote(note: dataSource.listofnotes[indexPath.row])
                                
                                self.dataSource.listofnotes.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                            } else {
                                CustomAlert.showAlert(title: "Face ID Error", message: error.debugDescription)
                            }
                        })
                        
                    } else {
                        deleteNote(note: dataSource.listofnotes[indexPath.row])
                        
                        self.dataSource.listofnotes.remove(at: indexPath.row)
                        
                        self.tableView.reloadData()
                    }
            }
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}
