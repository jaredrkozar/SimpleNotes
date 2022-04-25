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

    var newNoteVC = WSTagsField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Tags"
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        
        let nib = UINib(nibName: "TagTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TagTableViewCell")
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
        
        let tag = tags[indexPath.row]
        
        cell.tagImage.image = UIImage(systemName: tag.symbol!)?.withTintColor(UIColor(hex: tag.color!)!, renderingMode: .alwaysOriginal)
        
        cell.tagName.text = tag.name
        
        return cell
    }
    
    @objc func plusButtonTapped(sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newTagVC") as! NewTagViewController
        let navController = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if newNoteVC.tags.map({$0.text}).contains(tags[indexPath.row].name) {
            newNoteVC.removeTag(tags[indexPath.row].name!)
        } else {
            newNoteVC.addTag(tags[indexPath.row].name!)
        }
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(
              title: "Edit Tag", image: UIImage(systemName: "tag")) { [self] _ in
                //gets the current dimension and splits it up into 2 parts, and saves them so they can be shown in the text fields in editPresetViewController. The editPresetViewController is then shown via a popover
                
                  let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newTagVC") as! NewTagViewController
                  let navController = UINavigationController(rootViewController: vc)
                  vc.name = tags[indexPath.row].name
                  print(tags[indexPath.row].name)
                  vc.color = UIColor(hex: tags[indexPath.row].color!)
                  vc.image = tags[indexPath.row].symbol
                  
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
