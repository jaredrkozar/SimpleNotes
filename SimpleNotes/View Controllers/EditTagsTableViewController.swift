//
//  EditTagsTableViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/19/21.
//

import UIKit
import WSTagsField
import CoreData
import SwiftUI

class EditTagsTableViewController: UITableViewController {

    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Tags"
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "NoteTableViewCell")
        
        self.navigationItem.leftBarButtonItems = [plusButton]
        self.navigationItem.rightBarButtonItems = [doneButton]
        tableView.rowHeight = 70
        self.tableView.allowsMultipleSelection = true
        fetchTags()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
        
        let tag = tags[indexPath.row]

        cell.contentConfiguration = UIHostingConfiguration {
            IconCell(icon: RoundedIcon(icon: .systemImage(iconName: tag.symbol!, backgroundColor: Color.primary, tintColor: ThemeColors(rawValue: Int(tag.colorIndex))?.tintColor ?? Color.blue)), title: tag.name!, view: nil)
        }
        
        return cell
    }
    
    @objc func plusButtonTapped(sender: UIBarButtonItem) {
        presentTag(editingTag: false, name: nil, icon: nil, color: nil)
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if notes[index].tags?.contains(tags[indexPath.row]) == true {
            notes[index].removeFromTags(tags[indexPath.row])
        } else {
            print("inserted tag \(tags[indexPath.row].name!)")
            notes[index].addToTags(tags[indexPath.row])
        }
        
        NotificationCenter.default.post(name: Notification.Name("reloadNotesTable"), object: nil, userInfo: ["index":index])
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(
              title: "Edit Tag", image: UIImage(systemName: "tag")) { [self] _ in
                //gets the current dimension and splits it up into 2 parts, and saves them so they can be shown in the text fields in editPresetViewController. The editPresetViewController is then shown via a popover
                
                  presentTag(editingTag: true, name: tags[indexPath.row].name!, icon: tags[indexPath.row].symbol!, color: Int(tags[indexPath.row].colorIndex))
            }
            
            let deleteAction = UIAction(
                //deletes the current cell
              title: "Delete",
              image: UIImage(systemName: "trash"),
                attributes: .destructive) { [self] _ in
                    
                    deleteTag(tag: tags[indexPath.row])
                    
                    tags.remove(at: indexPath.row)
                    
                    self.tableView.reloadData()
            }
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
    
    func presentTag(editingTag: Bool, name: String?, icon: String?, color: Int?) {
        let vc = UIHostingController(rootView: NewTagViewController())
        let navController = UINavigationController(rootViewController: vc)
        if let picker = navController.presentationController as? UISheetPresentationController {
                    picker.detents = [.medium()]
                    picker.prefersGrabberVisible = true
                    picker.preferredCornerRadius = 5.0
                }
        if editingTag == true {
            vc.rootView.color = color!
            vc.rootView.icon = icon
            vc.rootView.name = name!
        }
        
        self.present(navController, animated: true)
    }
}
