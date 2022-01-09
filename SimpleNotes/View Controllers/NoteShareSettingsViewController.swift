//
//  NoteShareSettingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/8/22.
//

import UIKit

class NoteShareSettingsViewController: UITableViewController {

    @IBOutlet var sendNoteButton: CustomButton!
    
    var sharingLocation: SharingLocation?
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        sendNoteButton.setTitle(sharingLocation?.buttonMessage, for: .normal)
        title = sharingLocation?.viewTitle
    
        view.backgroundColor = UIColor.systemBackground
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                SharingType = .pdf
            } else {
                SharingType = .plainText
            }
        }
    }
}
