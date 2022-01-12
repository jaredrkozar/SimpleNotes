//
//  SettiingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/11/22.
//

import UIKit

class SettingsViewController: UITableViewController {

    var interactor = GoogleInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @IBAction func logOutButton(_ sender: Any) {
        interactor.signOut()
    }
}
