//
//  FolderLocationViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/10/22.
//

import UIKit

class FolderLocationViewController: UITableViewController {
    var noteView: NoteViewController?
    @IBOutlet var selectFolderButton: CustomButton!
    var location: SharingLocation?
    var currentfolder: String?
    var allFiles = [CloudServiceFiles]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Folders"
        
        let nib = UINib(nibName: "TableRowCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableRowCell")
        
    }

    override func viewDidAppear(_ animated: Bool) {

        if location == .googledrive {
            GoogleInteractor().fetchFiles(folderID: currentfolder ?? "root", onCompleted: {
                (files, error) in
                self.allFiles = files!
                print(self.allFiles.count)
                self.tableView.reloadData()
                
            })
        } else if location == .dropbox {
            DropboxInteractor().fetchFiles(folderID: currentfolder ?? "", onCompleted: {
                (files, error) in
                self.allFiles = files!
                
            })
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allFiles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowCell", for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the note cell.")
        }
         
        let file = allFiles[indexPath.row]
        cell.logOutButton.isHidden = true
        cell.name.text = file.name
        cell.icon.image = file.type.icon
        cell.background.backgroundColor = UIColor.clear
        
        if file.type.typeURL == "folder" {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = allFiles[indexPath.row]

        if  selectedFile.type == .folder {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "folderLocationsVC") as! FolderLocationViewController
            
            vc.currentfolder = selectedFile.folderID
            self.navigationController?.pushViewController(vc, animated: true)
            
           
        }
    }

}
