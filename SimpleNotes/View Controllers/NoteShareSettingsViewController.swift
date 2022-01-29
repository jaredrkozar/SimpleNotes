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
    var currentNote: Note?
    var currentNoteView: UIView!
    
    let google = GoogleInteractor()
    let dropbox = DropboxInteractor()
    
    var folderID: String?
    
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

            if google.isSignedIn == false && sharingLocation == .googledrive {
                google.signIn(vc: self)
            } else if  dropbox.isSignedIn == false && sharingLocation == .dropbox {
                dropbox.signIn(vc: self)
            } else if google.isSignedIn == true && sharingLocation == .googledrive {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "folderLocationsVC") as! FolderLocationViewController
                       let navController = UINavigationController(rootViewController: vc)
                       vc.currentfolder = ""
                vc.location = .googledrive
                
                self.navigationController?.present(navController, animated: true, completion: nil)
            } else if dropbox.isSignedIn == true && sharingLocation == .dropbox {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "folderLocationsVC") as! FolderLocationViewController
                       let navController = UINavigationController(rootViewController: vc)
                       vc.currentfolder = "root"
                vc.location = .dropbox
                
                self.navigationController?.present(navController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func didTapExportButton(_ sender: Any) {
        switch sharingLocation {
            case .email:
            sendEmail(noteTitle: (currentNote?.title)!, noteText: nil, noteDate: nil, notePDF: createPdfFromView(aView: currentNoteView) as Data)
            case .messages:
            sendText(noteTitle: (currentNote?.title)!, noteText: nil, noteDate: nil, notePDF: createPdfFromView(aView: currentNoteView) as Data)
            case .otherapps:
            
            sendToOtherApps(data: [createPdfFromView(aView: self.view), currentNote?.title!])
            case .googledrive:
            if google.isSignedIn {
                    google.signIn(vc: self)
                google.uploadFile(note: createPdfFromView(aView: currentNoteView) as Data, noteName: (currentNote?.title)!, folderID: folderID ?? nil)
                } else {
                    google.signIn(vc: self)
                }
        case .dropbox:
            if dropbox.isSignedIn == true {
                dropbox.uploadFile(note: createPdfFromView(aView: currentNoteView) as Data, noteName: (currentNote?.title)!, folderID: folderID ?? "/")
            } else {
                dropbox.signIn(vc: self)
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
        case .googledrive, .dropbox:
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
