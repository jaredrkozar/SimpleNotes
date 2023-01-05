//
//  FolderLocationViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/10/22.
//

import UIKit
import SwiftUI

class FolderLocationViewController: UITableViewController {
    
    var location: SharingLocation?
    var currentfolder: String?
    var allFiles = [CloudServiceFiles]()
    var serviceType: CloudType?
    var returnPDFData: ((_ returnData: Data, _ title: String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Folders"
        
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
        
        if serviceType == .upload {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select Folder", style: .done, target: self, action: #selector(selectFolderButton))
        }
    }

    override func viewDidAppear(_ animated: Bool) {

        guard location!.currentLocation.isSignedIn else {
            location!.currentLocation.signIn(vc: self)
            return
        }
        
        location?.currentLocation.fetchFiles(folderID: (currentfolder ?? location?.currentLocation.defaultFolder)!, onCompleted: {
            (files, error) in
            self.allFiles = files!
            
            self.tableView.reloadData()
            
        })
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
         
        var file = allFiles[indexPath.row]
        
        
        cell.configureCell(with: SettingsOptions(title: file.name, option: "", rowIcon: Icon(icon: "pin", iconBGColor: Color.green, iconTintColor: Color.purple), control: nil, handler: nil))
        
        if file.type.typeURL == "folder" {
            cell.accessoryType = .disclosureIndicator
        }
        
        if serviceType == .download {
            if file.type == .pdf || file.type == .folder {
                cell.isUserInteractionEnabled = true
            } else {
                cell.isUserInteractionEnabled = false
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedFile = allFiles[indexPath.row]
        
        if  selectedFile.type == .folder {
            let vc = FolderLocationViewController()
            vc.location = location
            vc.currentfolder = selectedFile.folderID
            vc.serviceType = serviceType
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if serviceType == .download {
            if selectedFile.type == .pdf {
                location?.currentLocation.downloadFile(identifier: selectedFile.folderID, folderID: selectedFile.folderID, onCompleted: {(files, error) in
                    self.dismiss(animated: true)
                    self.returnPDFData!(files!, selectedFile.name)
                })
            }
        }
    }

    @objc func selectFolderButton(_ sender: UIBarButtonItem) {
        let presenter = self.presentingViewController?.children.last as? NoteShareSettingsViewController
        presenter?.folderID = currentfolder
        
        self.dismiss(animated: true)
    }
    
}
