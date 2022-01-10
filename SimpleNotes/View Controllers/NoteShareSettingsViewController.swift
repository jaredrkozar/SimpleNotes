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
            if indexPath.row == 0 {
                format = SharingType.pdf
            } else {
                format = SharingType.plainText
            }
        }
        
    }
    
    @IBAction func didTapExportButton(_ sender: Any) {
        switch format {
            case .pdf:
                switch sharingLocation {
                    case .email:
                    sendEmail(noteTitle: noteTitle, noteText: nil, noteDate: nil, notePDF: PDFCreator().createPDF(noteTitle: noteTitle, noteText: noteText, noteDate: noteDate))
                    case .messages:
                        sendText(noteTitle: noteTitle, noteText: nil, noteDate: nil, notePDF: PDFCreator().createPDF(noteTitle: noteTitle, noteText: noteText, noteDate: noteDate))
                    case .otherapps:
                        sendToOtherApps(noteTitle: noteTitle, noteText: noteText, notePDF: nil)
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
                        sendToOtherApps(noteTitle: noteTitle, noteText: noteText, notePDF: nil)
                    default:
                        break
                }
            default:
                break
        }
    }
    
}
