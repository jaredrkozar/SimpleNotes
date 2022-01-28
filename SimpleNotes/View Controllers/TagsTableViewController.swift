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
        cell.name.text = tag.name
        
        cell.icon.image = tag.name?.sendBackSymbol(color: tag.color!)
        
        return cell
        
    }
    
    @objc func editTags(sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newNoteVC") as! NoteViewController
    }
}
