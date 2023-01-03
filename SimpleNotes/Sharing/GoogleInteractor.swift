//
//  GoogleInteractor.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/11/22.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher
import GTMAppAuth
import AppAuth

class GoogleInteractor: NSObject, GIDSignInDelegate, APIInteractor {
    
    var defaultFolder: String = "root"
    
    
    var driveService = GTLRDriveService()
    
    var driveUser: GIDGoogleUser?
    var clientID: String = "968933311910-9e4an07ni7ugfji5i8t6cfkj18h1861m.apps.googleusercontent.com"
    var filesInFolder = [CloudServiceFiles]()
    var folderID: String?
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //gets alled once the user signs in
        self.driveService.authorizer = user.authentication.fetcherAuthorizer()
        self.setValue("refreshtoken", forKey: user.authentication.refreshToken)
    }
    
    func handle(_ url: URL) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func signIn(vc: UIViewController) {
        
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
        
        GIDSignIn.sharedInstance().restorePreviousSignIn()
        if GIDSignIn.sharedInstance().hasPreviousSignIn() {
            driveService.apiKey = "AIzaSyBz0NAnojMb8LOmWUlEIHWTHvljk4Yboaw"
            driveService.authorizer = GIDSignIn.sharedInstance().currentUser.authentication.fetcherAuthorizer()
        } else {
            GIDSignIn.sharedInstance().presentingViewController = vc
            GIDSignIn.sharedInstance().delegate = vc as? GIDSignInDelegate
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    var isSignedIn: Bool {
        return GIDSignIn.sharedInstance().hasPreviousSignIn()
        
    }

    func signOut() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func fetchFiles(folderID: String, onCompleted: @escaping ([CloudServiceFiles]?, Error?) -> ()) {
        
        GIDSignIn.sharedInstance().restorePreviousSignIn()
       
        driveService.apiKey = "AIzaSyBz0NAnojMb8LOmWUlEIHWTHvljk4Yboaw"
        driveService.authorizer = GIDSignIn.sharedInstance().currentUser.authentication.fetcherAuthorizer()
        GIDSignIn.sharedInstance().clientID = clientID
 
         let query = GTLRDriveQuery_FilesList.query()
         query.pageSize = 100

         query.q = "'\(folderID)' in parents and trashed=false"
        query.fields = "files(id,kind,mimeType,name,size,iconLink)"
        
        query.includeItemsFromAllDrives = false
        query.corpora = "user"
        
        driveService.executeQuery(query) { (ticket, result, error) in
        
            if let filesList : GTLRDrive_FileList = result as? GTLRDrive_FileList {

                if let listOfFiles : [GTLRDrive_File] = filesList.files {
                    
                    for file in listOfFiles {
                        
                        self.filesInFolder.append(CloudServiceFiles(name: file.name!, type: self.getFileType(type: file.mimeType!), folderID: file.identifier!))
                    }
                    
                    onCompleted(self.filesInFolder, error)
                }
            }
        }
       }

    func uploadFile(note: Data, noteName: String, noteFormat: SharingType, folderID: String?, onCompleted: @escaping (Double, String?) -> ()) {
        
        GIDSignIn.sharedInstance().restorePreviousSignIn()
       
        driveService.apiKey = "AIzaSyBz0NAnojMb8LOmWUlEIHWTHvljk4Yboaw"
        driveService.authorizer = GIDSignIn.sharedInstance().currentUser.authentication.fetcherAuthorizer()
        GIDSignIn.sharedInstance().clientID = clientID
 
        
        let file = GTLRDrive_File()
        file.name = noteName
        file.parents = ["root"]
        let params = GTLRUploadParameters(data: note, mimeType: noteFormat.googleDriveFileType)
    
       params.shouldUploadWithSingleRequest = true
  
       let upload = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: params)
        upload.fields = "id"
        
        let gkkg = ToastNotification(backgroundColor: .systemBlue, image: UIImage(systemName: "icloud.and.arrow.up")!, titleText: "DDDD", progress: 0.0)
        
        driveService.uploadProgressBlock = { _, uploaded, total in
            
            gkkg.updateProgress(progress: Float((uploaded / total)) * 100)
        }
        
        self.driveService.executeQuery(upload, completionHandler:  { (response, result, error) in
            gkkg.removeFromSuperview()
            
            let finishedUpload = ToastNotification(backgroundColor: .systemGreen, image: UIImage(systemName: "checkmark.circle")!, titleText: "Upload Complete", subtitleText: "The upload is finished. Your can view the note in the Google Drive app or on the website")
        })
    }
    
    func downloadFile(identifier: String, folderID: String?, onCompleted: @escaping (Data?, Error?) -> ()) {
        
        GIDSignIn.sharedInstance().restorePreviousSignIn()
       
        driveService.apiKey = "AIzaSyBz0NAnojMb8LOmWUlEIHWTHvljk4Yboaw"
        driveService.authorizer = GIDSignIn.sharedInstance().currentUser.authentication.fetcherAuthorizer()
        GIDSignIn.sharedInstance().clientID = clientID
 
        
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: identifier)
         driveService.executeQuery(query) { (ticket, file, error) in
             onCompleted((file as? GTLRDataObject)?.data, error)
         }
    }
    
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().restorePreviousSignIn()

    }
    
    func getFileType(type: String) -> MimeTypes {
        switch type {
            case "application/vnd.google-apps.folder":
                return .folder
            case "application/pdf":
                return .pdf
            case "application/vnd.google-apps.document":
                return .document
            case "application/vnd.google-apps.spreadsheet":
                return .spreadsheet
            case "application/vnd.google-apps.presentation":
                return .presentation
            case "application/vnd.google-apps.audio":
                return .audiofile
            case "application/vnd.google-apps.unknown":
                return .other
            default:
                return .other
        }
        
    }
    
}
