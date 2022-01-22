//
//  DropboxInteractor.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/20/22.
//

import UIKit
import SwiftyDropbox

class DropboxInteractor: APIInteractor {

    var filesInFolder = [CloudServiceFiles]()
    
    func fetchFiles(folderID: String?, onCompleted: @escaping ([CloudServiceFiles]?, Error?) -> ()) {
        if let client = DropboxClientsManager.authorizedClient {
            client.files.listFolder(path: folderID!).response { response, error in
                        if let result = response {
                    
                            for file in result.entries {
                                var isFolder: Bool = true
                                
                                if file is Files.FileMetadata {
                                    isFolder = false
                                }
                                
                                self.filesInFolder.append(CloudServiceFiles(name: file.name, type: isFolder ? "folder" : self.getFileType(type: file.name), folderID: ""))
                            }
                            
                            onCompleted(self.filesInFolder, nil)
                            
                        } else {
                            print(error!)
                        }
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
    
    func getFileType(type: String) -> String {
        var fileType = ""
        
        let type = (type as NSString).pathExtension

        switch type {
            case "txt", "md", "html":
                fileType = "document"
            case "xlxs", "xls", "xlm", "xl", "gsheet":
                fileType = "spreadsheet"
            case "pdf":
                fileType = "pdf"
            case "ppt", "pptx", "pptm", "gslides":
                fileType = "presentation"
            case "mp3", "m4a", "flac", "mp4", "wav":
                fileType = "audiofile"
            default:
                fileType = "other"
        }
        return fileType
    }
}
