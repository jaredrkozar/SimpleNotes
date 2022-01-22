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
    
    var driveService = GTLRDriveService()
    var driveUser: GIDGoogleUser?
    var clientID: String = "968933311910-9e4an07ni7ugfji5i8t6cfkj18h1861m.apps.googleusercontent.com"
    var filesInFolder = [CloudServiceFiles]()
    var folderID: String?
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.driveService.authorizer = user.authentication.fetcherAuthorizer()
        self.setValue("refreshtoken", forKey: user.authentication.refreshToken)
    }
    
    func handle(_ url: URL) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func signIn(vc: UIViewController) {
        GIDSignIn.sharedInstance().clientID = clientID
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
        GIDSignIn.sharedInstance().delegate = vc as? GIDSignInDelegate
        GIDSignIn.sharedInstance()?.presentingViewController = vc
        
        if(isSignedIn == true) {
            GIDSignIn.sharedInstance().restorePreviousSignIn()
            driveService.authorizer = GIDSignIn.sharedInstance().currentUser.authentication.fetcherAuthorizer()
            driveService.apiKey = "AIzaSyBz0NAnojMb8LOmWUlEIHWTHvljk4Yboaw"
            print("restorex")
        } else {
            GIDSignIn.sharedInstance().signIn()

        }
    }
    
    var isSignedIn: Bool {
        return GIDSignIn.sharedInstance().hasPreviousSignIn()
        
    }

    func signOut() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func fetchFiles(folderID: String?, onCompleted: @escaping ([CloudServiceFiles]?, Error?) -> ()) {
        let currentFolder = folderID ?? "root"
         let query = GTLRDriveQuery_FilesList.query()
         query.pageSize = 100
         query.q = "'\(currentFolder)' in parents and trashed=false"
         query.fields = "files(id,name,mimeType,modifiedTime,createdTime,fileExtension,size),nextPageToken"
        query.includeItemsFromAllDrives = false
        query.corpora = "user"
        
        driveService.executeQuery(query, completionHandler: { [self](ticket, files, error) in

             if let filesList : GTLRDrive_FileList = files as? GTLRDrive_FileList {

                 if let listOfFiles : [GTLRDrive_File] = filesList.files {
                     
                     for file in listOfFiles {
                         filesInFolder.append(CloudServiceFiles(name: file.name!, type: getFileType(type: file.mimeType!), folderID: file.identifier!))
                     }
                     onCompleted(filesInFolder, error)
                 }
             }
         })
       }

    func uploadFile(note: Data, noteName: String, folderID: String?) {
        
        let file = GTLRDrive_File()
        file.name = noteName
       
        let params = GTLRUploadParameters(data: note, mimeType: "application/pdf")
       params.shouldUploadWithSingleRequest = true
  
       let upload = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: params)
        
       self.driveService.executeQuery(upload, completionHandler:  { (response, result, error) in
      
           guard error == nil else {
               print(error!.localizedDescription)
               return
           }}
       )
    }
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().clientID = clientID
        if GIDSignIn.sharedInstance().currentUser != nil {
        self.driveService.authorizer = GIDSignIn.sharedInstance().currentUser.authentication.fetcherAuthorizer()
        }
    }
    
    func getFileType(type: String) -> String {
        var fileType = ""
        switch type {
        case "application/vnd.google-apps.folder":
                fileType = "folder"
            case "application/pdf":
                fileType = "pdf"
            case "application/vnd.google-apps.document":
                fileType = "document"
            case "application/vnd.google-apps.spreadsheet":
                fileType = "spreadsheet"
            case "application/vnd.google-apps.presentation":
                fileType = "presentation"
            case "application/vnd.google-apps.audio":
                fileType = "audiofile"
            case "application/vnd.google-apps.unknown":
                fileType = "other"
                default:
                fileType = "other"
        }
        
        
        return fileType
    }
    
}
