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
        tableView.reloadData()
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 0
        
        switch sharingLocation {
            case .email:
                if section == 0 {
                        numRows = 2
                } else {
                    numRows = 0
                }
            case .messages:
            if section == 0 {
                    numRows = 2
            } else {
                numRows = 2
            }
            case .otherapps:
            if section == 0 {
                    numRows = 2
            } else {
                numRows = 0
            }
        case .googledrive:
            if section == 1 {
                    numRows = 1
            } else {
                numRows = 0
            }
            case .none:
                break
        }
        return numRows
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                format = SharingType.pdf
            } else {
                format = SharingType.plainText
            }
            
        } else if indexPath.section == 1 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "folderLocationsVC") as! FolderLocationViewController
            let navController = UINavigationController(rootViewController: vc)
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func didTapExportButton(_ sender: Any) {
        switch format {
            case .pdf:
                switch sharingLocation {
                    case .email:
                    sendEmail(noteTitle: noteTitle, noteText: nil, noteDate: nil, notePDF: PDFCreator().createPDF(noteTitle: noteTitle, noteText: noteText, noteDate: "Created on \(noteDate)"))
                    case .messages:
                        sendText(noteTitle: noteTitle, noteText: nil, noteDate: nil, notePDF: PDFCreator().createPDF(noteTitle: noteTitle, noteText: noteText, noteDate: "Created on \(noteDate)"))
                    case .otherapps:
                    
                    sendToOtherApps(data: [PDFCreator().createPDF(noteTitle: noteTitle, noteText: noteText, noteDate: "Created on \(noteDate)"), noteTitle])
                    default:
                        break
                }
            case .plainText:
                switch sharingLocation {
                    case .email:
                        sendEmail(noteTitle: noteTitle, noteText: noteText, noteDate: noteDate, notePDF: nil)
                    case .messages:
                        sendText(noteTitle: noteTitle, noteText: noteText, noteDate: noteDate, notePDF: nil)
                    case .otherapps:
                    sendToOtherApps(data: ["Title \(noteTitle). Text \(noteText)"])
                    default:
                        break
                }
            default:
                break
        }
    }
    
}
