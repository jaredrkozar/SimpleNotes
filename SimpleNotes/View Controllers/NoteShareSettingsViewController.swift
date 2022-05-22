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

    var format: SharingType?
    var currentNote: Note?
    var currentNoteView: Data!
    var sharingLocation: SharingLocation?
    
    var currentLocation: APIInteractor {
        if self.sharingLocation == .googledrive {
            return GoogleInteractor()
        } else {
            return DropboxInteractor()
        }
    }
    
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

            if currentLocation.isSignedIn == false {
                currentLocation.signIn(vc: self)
            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "folderLocationsVC") as! FolderLocationViewController
                       let navController = UINavigationController(rootViewController: vc)
                vc.location = sharingLocation
                vc.currentfolder = currentLocation.defaultFolder
                self.navigationController?.present(navController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func didTapExportButton(_ sender: Any) {
        
        switch sharingLocation {
            case .email:
                sendEmail(noteTitle: (currentNote?.title)!, noteText: nil, noteDate: nil, notePDF: currentNoteView)
            case .messages:
                sendText(noteTitle: (currentNote?.title)!, noteText: nil, noteDate: nil, notePDF: currentNoteView)
            case .otherapps:
            
                sendToOtherApps(data: [currentNoteView, currentNote?.title! ?? ""])
        case .googledrive, .dropbox:
     
            uploadFileToCloud(folder: folderID ?? currentLocation.defaultFolder)
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
    
    func uploadFileToCloud(folder: String) {

        if currentLocation.isSignedIn {
            currentLocation.uploadFile(note: currentNoteView, noteName: (currentNote?.title)!, folderID: folder)
        } else {
            currentLocation.signIn(vc: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
