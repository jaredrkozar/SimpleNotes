//
//  NoteShareSettingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/8/22.
//

import UIKit
import GoogleSignIn

class NoteShareSettingsViewController: UITableViewController {
    
    @IBOutlet var sendNoteButton: CustomButton!

    var sharingLocation: SharingLocation?
    var format: SharingType?
    var noteTitle: String = ""
    var noteText: String = ""
    var noteDate: String = ""
    
    let google = GoogleInteractor()
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        sendNoteButton.setTitle(sharingLocation?.buttonMessage, for: .normal)
        
        title = sharingLocation?.viewTitle
    
        view.backgroundColor = UIColor.systemBackground
        tableView.reloadData()
        
        format = .pdf
    
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionShouldBeHidden(section) {
            return nil // Show nothing for the header of hidden sections
        } else {
            return super.tableView(tableView, titleForHeaderInSection: section) // Use the default header for other sections
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionShouldBeHidden(section) {
                return 0 // Don't show any rows for hidden sections
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section) // Use the default number of rows for other sections
        }
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
                    case .googledrive:
                    
                    google.signIn(vc: self)
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
    
    private func sectionShouldBeHidden(_ section: Int) -> Bool {
        var shouldHideSection: Bool = false
        
        switch sharingLocation {
        case .email, .messages, .otherapps:
            switch section {
                case 1:
                    shouldHideSection = true
                default:
                    shouldHideSection =  false
            }
        case .googledrive:
            switch section {
                case 0:
                    shouldHideSection = true
                default:
                    shouldHideSection = false
            }
            case .none:
                break
        }
        return shouldHideSection
    }

}
