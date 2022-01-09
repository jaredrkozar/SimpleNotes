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
    var format: SharingType?
    var noteTitle: String = ""
    var noteText: String = ""
    var noteDate: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        sendNoteButton.setTitle(sharingLocation?.buttonMessage, for: .normal)
        title = sharingLocation?.viewTitle
    
        view.backgroundColor = UIColor.systemBackground
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                format = SharingType.pdf
            } else {
                format = SharingType.plainText
            }
        }
    }
    
    @IBAction func didTapExportButton(_ sender: Any) {
        
        switch format {
            case .pdf:
                print("DDD")
            case .plainText:
                switch sharingLocation {
                    case .email:
                    sendEmail(noteTitle: noteTitle, noteText: noteText, noteDate: noteDate, notePDF: nil)
                    case .messages:
                        print("MEssages")
                    default:
                        break
                }
            default:
                break
        }
    }
    
}
