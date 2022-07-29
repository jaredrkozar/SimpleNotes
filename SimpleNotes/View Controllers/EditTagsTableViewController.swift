//
//  EditTagsTableViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/19/21.
//

import UIKit
import WSTagsField
import CoreData

class EditTagsTableViewController: UITableViewController {

    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Tags"
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowCell", for: indexPath) as! TableRowCell
        
        let tag = tags[indexPath.row]
        
        cell.configureCell(with: SettingsOptions(title: tag.name!, option: "", rowIcon: Icon(icon: UIImage(systemName: tag.symbol!), iconBGColor: .systemBackground, iconTintColor: UIColor(hex: tag.color!)), control: nil, handler: nil))
        
        return cell
    }
    
    @objc func plusButtonTapped(sender: UIBarButtonItem) {
        let vc = NewTagViewController()
        let navController = UINavigationController(rootViewController: vc)
        vc.selectedColor = .systemBlue
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if ((note?.tags?.contains(tags[indexPath.item].name!)) != nil) {
            note?.tags?.remove(tags[indexPath.item].name!)
           print("ADDED")
            print(tags[indexPath.item].name)
        } else {
            print("removed")
            note?.tags?.insert(tags[indexPath.item].name!)
        }
       
        print(note?.tags)
        do {
            try context.save()
        } catch {
            print("An error occured while saving a note.")
        }
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(
              title: "Edit Tag", image: UIImage(systemName: "tag")) { [self] _ in
                //gets the current dimension and splits it up into 2 parts, and saves them so they can be shown in the text fields in editPresetViewController. The editPresetViewController is then shown via a popover
                
                  let vc = NewTagViewController()
                  let navController = UINavigationController(rootViewController: vc)
                  vc.isEditingTag = true
                  vc.currentTag = tags[indexPath.row]
                  vc.selectedColor = UIColor(hex: tags[indexPath.row].color!)
                  vc.image = tags[indexPath.row].symbol
                  vc.name = tags[indexPath.row].name
                  vc.isEditingTag = true
                  self.navigationController?.present(navController, animated: true, completion: nil)
                
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
    
}
