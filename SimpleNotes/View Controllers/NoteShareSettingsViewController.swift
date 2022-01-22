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
    
    let google = GoogleInteractor()
    let dropbox = DropboxInteractor()
    
    var folderID: String?
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert(_:)), name: NSNotification.Name( "fileUploaded"), object: nil)

    }
    
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
        switch format {
            case .pdf:
                switch sharingLocation {
                    case .email:
                    sendEmail(noteTitle: (currentNote?.title)!, noteText: nil, noteDate: nil, notePDF: PDFCreator().createPDF(noteTitle: (currentNote?.title)!, noteText: currentNote?.text, noteDate: "Created on \(currentNote!.date?.formatted() ?? Date.now.formatted())"))
                    case .messages:
                    sendText(noteTitle: (currentNote?.title)!, noteText: nil, noteDate: nil, notePDF: PDFCreator().createPDF(noteTitle: (currentNote?.title)!, noteText: currentNote?.text, noteDate: "Created on \(currentNote!.date?.formatted() ?? Date.now.formatted())"))
                    case .otherapps:
                    
                    sendToOtherApps(data: [PDFCreator().createPDF(noteTitle: (currentNote?.title)!, noteText: currentNote?.text, noteDate: "Created on \(currentNote!.date?.formatted() ?? Date.now.formatted())"), currentNote?.title!])
                    case .googledrive:
                    if google.isSignedIn {
                            google.signIn(vc: self)
                            google.uploadNote(note: PDFCreator().createPDF(noteTitle: (currentNote?.title)!, noteText: currentNote?.text, noteDate: "Created on \(currentNote!.date?.formatted() ?? Date.now.formatted())"), noteName: (currentNote?.title)!, folderID: folderID ?? nil)
                        } else {
                            google.signIn(vc: self)
                        }
                case .dropbox:
                    if dropbox.isSignedIn == true {
                        print("Signed in to dropbox")
                    } else {
                        dropbox.signIn(vc: self)
                    }
                    default:
                        break
                }
            case .plainText:
                switch sharingLocation {
                    case .email:
                    sendEmail(noteTitle: (currentNote?.title)!, noteText: currentNote?.text, noteDate: currentNote?.date?.formatted(), notePDF: nil)
                    case .messages:
                    sendText(noteTitle: (currentNote?.title)!, noteText: currentNote?.text, noteDate: currentNote?.date?.formatted(), notePDF: nil)
                    case .otherapps:
                    sendToOtherApps(data: ["Title \(String(describing: currentNote?.title)). Text \(String(describing: currentNote?.text))"])
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

    @objc func showAlert(_ notification: Notification) {
        let alert = UIAlertController(title: "Note uploaded successfully", message: "The note was uploaded successully", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
}
