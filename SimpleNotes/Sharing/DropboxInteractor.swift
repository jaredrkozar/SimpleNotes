//
//  DropboxInteractor.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/20/22.
//

import UIKit
import SwiftyDropbox

class DropboxInteractor: APIInteractor {
    
    func getFileType(type: String) -> String {
        return "DDD"
    }
    var filesInFolder = [CloudServiceFiles]()
    
    func fetchFiles(folderID: String?, onCompleted: @escaping ([CloudServiceFiles]?, Error?) -> ()) {
        if let client = DropboxClientsManager.authorizedClient {
            client.files.listFolder(path: folderID!).response { response, error in
                        if let result = response {

                            for file in result.entries {
                                self.filesInFolder.append(CloudServiceFiles(name: file.name, type: file.description, folderID: "DDD"))
                            }
                            
                            onCompleted(self.filesInFolder, nil)
                            
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
