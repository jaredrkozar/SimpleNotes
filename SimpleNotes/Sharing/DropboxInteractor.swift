//
//  DropboxInteractor.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/20/22.
//

import UIKit
import SwiftyDropbox
import PDFKit

class DropboxInteractor: APIInteractor {
    
    var defaultFolder: String = ""
    
    var filesInFolder = [CloudServiceFiles]()
    let client = DropboxClientsManager.authorizedClient

    init() {
        if isSignedIn == false {
            signIn()
        }
    }
    
    
    func fetchFiles(folderID: String, onCompleted: @escaping ([CloudServiceFiles]?, Error?) -> ()) {
 
        client?.files.listFolder(path: folderID).response { [self] response, error in
            if let result = response {
        
                for file in result.entries {
                    var isFolder: Bool = true
                    
                    if file is Files.FileMetadata {
                        isFolder = false
                    }
                
                    self.filesInFolder.append(CloudServiceFiles(name: file.name, type: isFolder == true ? .folder : self.getFileType(type: file.name), folderID: file.pathLower!))
                }
                
                onCompleted(self.filesInFolder, nil)
                
            }
        }

            
    }
    
    func signIn() {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: [], includeGrantedScopes: false)
            DropboxClientsManager.authorizeFromControllerV2(
                UIApplication.shared,
                controller: getRootViewController(),
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
    
    func uploadFile(note: Data, noteName: String, noteFormat: SharingType, folderID: String?, onCompleted: @escaping (Double, String?) -> ()) {
        var progress: Double?
        let newPath = folderID! + "/\(noteName).pdf)"
        client?.files.upload(path: newPath, mode: .add, autorename: true, clientModified: nil, mute: false, input: note)
            
            .progress { progressData in
                progress = progressData.fractionCompleted
                print(progress)
            }
        
            .response(queue: DispatchQueue.global(qos: .userInteractive), completionHandler: { response, error in
                if let _ = response {
                    onCompleted(progress ?? 0.0, "D")
                }
               
            })
    }
    
    func downloadFile(identifier: String, folderID: String?, onCompleted: @escaping (Data?, Error?) -> ()) {

        let destination : (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            let fileManager = FileManager.default
            let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
              // generate a unique name for this file in case we've seen it before
            let UUID = NSUUID().uuidString
              let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
            return directoryURL.appendingPathComponent(pathComponent, conformingTo: .fileURL)
          }

        client?.files.download(path: folderID!, rev: nil, overwrite: true, destination: destination)
            .response { response, error in
                if let dropboxData = try? Data(contentsOf: response!.1) {
                    onCompleted(dropboxData, nil)
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
