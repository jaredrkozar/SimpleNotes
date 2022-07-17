//
//  FolderLocationViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/10/22.
//

import UIKit

class FolderLocationViewController: UITableViewController {
    
    var noteView: NoteViewController?
    
    var location: SharingLocation?
    var currentfolder: String?
    var allFiles = [CloudServiceFiles]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Folders"
        
        let nib = UINib(nibName: "TableRowCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableRowCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select Folder", style: .done, target: self, action: #selector(selectFolderButton))
    }

    override func viewDidAppear(_ animated: Bool) {

        if location == .googledrive {
           
            GoogleInteractor().fetchFiles(folderID: currentfolder ?? "root", onCompleted: {
                (files, error) in
                self.allFiles = files!
                
                self.tableView.reloadData()
                
            })
        } else if location == .dropbox {
            DropboxInteractor().fetchFiles(folderID: currentfolder ?? "/", onCompleted: {
                (files, error) in
                self.allFiles = files!
                
                self.tableView.reloadData()
                
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
        
        
        cell.configureCell(with: SettingsOptions(title: file.name, option: "", rowIcon: Icon(icon: UIImage(systemName: "pin"), iconBGColor: .systemRed, iconTintColor: .systemYellow), control: nil, handler: nil))
        
        if file.type.typeURL == "folder" {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedFile = allFiles[indexPath.row]

        if  selectedFile.type == .folder {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "folderLocationsVC") as! FolderLocationViewController
            vc.location = location
            vc.currentfolder = selectedFile.folderID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func selectFolderButton(_ sender: UIBarButtonItem) {
        print(currentfolder)
        let presenter = self.presentingViewController?.children.last as? NoteShareSettingsViewController
        presenter?.folderID = currentfolder
        
        self.dismiss(animated: true)
    }
    
}
