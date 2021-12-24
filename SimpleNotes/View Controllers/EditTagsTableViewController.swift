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
        print("DDD")
        tableView.reloadData()
    }
    // MARK: - Table view data source

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
        
        cell.tagImage.image = tag.symbol?.toImage()
        
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newNoteVC.addTag(tags[indexPath.row].name!)
    }

    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        newNoteVC.removeTag(tags[indexPath.row].name!)
    }
}
