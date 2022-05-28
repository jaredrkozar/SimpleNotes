//
//  DropboxInteractor.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/20/22.
//

import UIKit
import SwiftyDropbox

class DropboxInteractor: APIInteractor {
    var defaultFolder: String = ""
    
    var filesInFolder = [CloudServiceFiles]()
    let client = DropboxClientsManager.authorizedClient

    func fetchFiles(folderID: String, onCompleted: @escaping ([CloudServiceFiles]?, Error?) -> ()) {
        
        client!.files.listFolder(path: folderID).response { [self] response, error in
            if let result = response {
        
                for file in result.entries {
                    var isFolder: Bool = false
                    
                    if file is Files.FileMetadata {
                        isFolder = true
                    }
                
                    self.filesInFolder.append(CloudServiceFiles(name: file.name, type: isFolder ? self.getFileType(type: file.name) : .folder, folderID: file.pathLower!))
                }
                
                onCompleted(self.filesInFolder, nil)
                
            }
        }

            
    }
    
    func signIn(vc: UIViewController) {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: [], includeGrantedScopes: false)
            DropboxClientsManager.authorizeFromControllerV2(
                UIApplication.shared,
                controller: vc,
                loadingStatusDelegate: nil,
                openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
                scopeRequest: scopeRequest
            )
    }
    
    var isSignedIn: Bool {
        if DropboxClientsManager.authorizedClient == nil {
            return false
        } else {
            return true
        }
        
    }
    
    func signOut() {
        DropboxClientsManager.unlinkClients()
    }
    
    func uploadFile(note: Data, noteName: String, folderID: String, onCompleted: @escaping (Double, String?) -> ()) {

        let newPath = folderID + "/\(noteName).pdf"
        var request = client?.files.upload(path: newPath, mode: .add, autorename: true, clientModified: Date(), mute: true, propertyGroups: nil, strictConflict: true, input: note)
        
            .response { response, error in
                if let response = response {
                    ToastNotification().showToast(backgroundColor: .systemGreen, image: UIImage(systemName: "checkmark.circle.fill")!, titleText: "File uploaded to Dropbox", subtitleText: "The note was successfully uplrmmrmrmrmr rkrkkrkrkrkrrk  rkrkrkkrkkrkrkr  rkrkrkrkrkkrr rkrkkrkrr oaded to Dropbox", progress: nil)
                } else if let error = error {
                    ToastNotification().showToast(backgroundColor: .systemGreen, image: UIImage(systemName: "exclamationmark.icloud")!, titleText: "Error uploading note to Dropbox", subtitleText: error.description, progress: nil)
                }
            }
    }
    
    
    func getFileType(type: String) -> MimeTypes {
        let type = (type as NSString).pathExtension

        switch type {
            case "txt", "md", "html":
            return .document
            case "xlxs", "xls", "xlm", "xl", "gsheet":
            return .spreadsheet
            case "pdf":
            return .pdf
            case "ppt", "pptx", "pptm", "gslides":
            return .presentation
            case "mp3", "m4a", "flac", "mp4", "wav":
            return .audiofile
            default:
            return .other
        }
        
    }
}
