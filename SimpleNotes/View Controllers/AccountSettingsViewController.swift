//
//  AccountSettingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/21/22.
//

import UIKit

class AccountSettingsViewController: UITableViewController {

    var models = [Sections]()
    
    override func viewDidLoad() {
        let nib = UINib(nibName: "TableRowCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableRowCell")
        
        configure()
        
        title = "Account Settings"

        returnCell(num: 0).logOutButton.setTitle("Lolkkkk", for: .normal)
        
        
        tableView.rowHeight = 70
        
        print(models[0].settings.count)
    
    }

    func returnCell(num: Int) -> TableRowCell {
        let cell = tableView(tableView, cellForRowAt: NSIndexPath(row: num, section: num) as IndexPath) as! TableRowCell
        
        return cell
        
    }
    
    func configure() {
        models.append(Sections(title: "Advanced", settings: [
            SettingsOptions(title: "Google Drive", option: "", icon: UIImage(named: "GoogleDrive"), iconBGColor: UIColor(named: "Yellow")!) {
                            
                GoogleInteractor().signOut()
                },
                        
                SettingsOptions(title: "Dropbox", option: "", icon: UIImage(named: "Dropbox"), iconBGColor: UIColor(named: "Blue")!) {
                  
                    DropboxInteractor().signOut()
                    
                },
        ])
        )
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return  models.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models[section].settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowCell", for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the settings cell.")
        }
        
        let model = models[indexPath.section].settings[indexPath.row]
        
        cell.logOutButton.isHidden = false
        
        cell.icon.image = model.icon?.withTintColor(UIColor.white)
        cell.background.backgroundColor = model.iconBGColor
        
        cell.name.text = model.title
        
        cell.background.layer.cornerRadius = 9.0
        cell.icon.tintColor = UIColor.white
        cell.cellIndex = indexPath
        cell.delegate = self
        
        return cell
    }
}

extension AccountSettingsViewController: TableRowCellDelegate {
    func buttonTapped(num: Int) {
            
        switch num {
            case 0:

                if GoogleInteractor().isSignedIn == true {
                    returnCell(num: 0).logOutButton.setTitle("Log Out", for: .normal)
                    GoogleInteractor().signOut()
                    tableView.reloadData()
                } else {
                    GoogleInteractor().signIn(vc: self)
                    returnCell(num: 0).logOutButton.setTitle("Log In", for: .normal)
                    tableView.reloadData()
                }
            tableView.reloadData()
            case 1:
            if DropboxInteractor().isSignedIn == true {
                DropboxInteractor().signOut()
                returnCell(num: 1).logOutButton.setTitle("Log Out", for: .normal)
                tableView.reloadData()
                } else {
                    DropboxInteractor().signIn(vc: self)
                    returnCell(num: 1).logOutButton.setTitle("Log In", for: .normal)
                    tableView.reloadData()
                }
        default:
            return
        }
    }
}
