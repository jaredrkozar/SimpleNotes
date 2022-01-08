//
//  ViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/8/21.
//

import UIKit

class ViewController: UITableViewController, UINavigationControllerDelegate {

    var dataSource = ReusableTableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchNotes()
        tableView.dataSource = dataSource
        dataSource.listofnotes = notes
        
        let nib = UINib(nibName: "NoteTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NoteTableViewCell")
        
        tableView.rowHeight = 180
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addNote = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addNote))
        
        let settings = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsScreen))

        self.navigationItem.rightBarButtonItems = [addNote, settings]
        
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateNotesTable(_:)), name: NSNotification.Name( "UpdateNotesTable"), object: nil)
    }
    
    @objc func UpdateNotesTable(_ notification: Notification) {
        self.tableView.reloadData()
        tableView.reloadData()
    }
    
    @objc func addNote(sender: UIBarButtonItem) {
  
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newNoteVC") as! NewNoteViewController
        vc.isEditingNote = false
        let navController = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }

    @objc func settingsScreen(sender: UIButton) {
        print("UII")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newNoteVC") as! NewNoteViewController
        vc.isEditingNote = true
        vc.currentNote = dataSource.listofnotes[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
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
                    
                    deleteNote(note: dataSource.listofnotes[indexPath.row])
                    
                    self.dataSource.listofnotes.remove(at: indexPath.row)
                    
                    self.tableView.reloadData()
                    
                
            }
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
    
}
