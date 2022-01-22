//
//  DropboxInteractor.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/20/22.
//

import UIKit
import SwiftyDropbox

class DropboxInteractor: APIInteractor {
   
    func fetchFiles(folderID: String?, onCompleted: @escaping ([AnyObject]?, Error?) -> ()) {
        if let client = DropboxClientsManager.authorizedClient {
            client.files.listFolder(path: folderID!).response { response, error in
                        if let result = response {
                            print("Folder contents:")
                            for entry in result.entries {
                                client.files.getMetadata(path: (entry.pathLower)!).response { response, error in
                                    if let metadata = response {
                                        if let folder = metadata as? Files.FolderMetadata {
                                            print(folder.name)
                                        }
                                    }
                                }
                            }
                        } else {
                            print(error!)
                        }
                    }
                }
    }
    
    func fetchFiles() {
        print("DD")
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
    


}
