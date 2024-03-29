//
//  TagsTableViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/23/22.
//

import UIKit
import SwiftUI

class TagsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "TableRowCell")
        
        title = "Tags"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchTags()
        
        let editTagsButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(editTags))

        self.navigationItem.rightBarButtonItems = [editTagsButton]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = tags[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowCell", for: indexPath) as? NoteTableViewCell else {
            fatalError("Unable to dequeue the settings cell.")
        }
        
        cell.contentConfiguration = UIHostingConfiguration {
            IconCell(icon: RoundedIcon(icon: .systemImage(iconName: tag.symbol!, backgroundColor: Color.primary, tintColor: ThemeColors(rawValue: Int(tag.colorIndex))?.tintColor ?? Color.blue)), title: tag.name!, view: nil)
        }
        return cell
        
    }
    
    @objc func editTags(sender: UIBarButtonItem) {
        let vc = UIHostingController(rootView: NewTagViewController())
        
        let navController = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewController()
        let navController = UINavigationController(rootViewController: vc)
        vc.currentTag = tags[indexPath.row].name

        self.navigationController?.pushViewController(navController, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(
              title: "Edit Tags", image: UIImage(systemName: "tag")) { [self] _ in
                //gets the current dimension and splits it up into 2 parts, and saves them so they can be shown in the text fields in editPresetViewController. The editPresetViewController is then shown via a popover
                  
                  let vc = UIHostingController(rootView: NewTagViewController())
                  let navController = UINavigationController(rootViewController: vc)
                  vc.rootView.color = Int(tags[indexPath.row].colorIndex)
                  vc.rootView.icon = tags[indexPath.row].symbol
                  vc.rootView.name = tags[indexPath.row].name!
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
