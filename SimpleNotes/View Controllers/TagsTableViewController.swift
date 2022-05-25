//
//  TagsTableViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/23/22.
//

import UIKit

class TagsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "TableRowCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableRowCell")
        
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

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowCell", for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the settings cell.")
        }
        
        cell.logOutButton.isHidden = true
        cell.background.backgroundColor = UIColor.clear
       
        cell.icon.image = UIImage(systemName: tag.symbol!)?.withTintColor(UIColor(hex: tag.color!)!, renderingMode: .alwaysOriginal)
        
        cell.name.text = tag.name
        
        
        return cell
        
    }
    
    @objc func editTags(sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newTagVC") as! NewTagViewController
        
        let navController = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navController = UINavigationController(rootViewController: vc)
        vc.currentTag = tags[indexPath.row].name
        vc.viewAppeared()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(
              title: "Edit Tags", image: UIImage(systemName: "tag")) { [self] _ in
                //gets the current dimension and splits it up into 2 parts, and saves them so they can be shown in the text fields in editPresetViewController. The editPresetViewController is then shown via a popover
                  
                  let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newTagVC") as! NewTagViewController
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
