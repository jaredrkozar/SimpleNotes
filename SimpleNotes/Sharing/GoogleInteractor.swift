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
    
    func fetchFolders(folderID: String?, onCompleted: @escaping ([GTLRDrive_File]?, Error?) -> ()) {
        let currentFolder = folderID ?? "root"
         let query = GTLRDriveQuery_FilesList.query()
         query.pageSize = 100
         query.q = "'\(currentFolder)' in parents and trashed=false"
         query.fields = "files(id,name,mimeType,modifiedTime,createdTime,fileExtension,size),nextPageToken"
        query.includeItemsFromAllDrives = false
        query.corpora = "user"
        
         driveService.executeQuery(query, completionHandler: {(ticket, files, error) in

             if let filesList : GTLRDrive_FileList = files as? GTLRDrive_FileList {
                 if let listOfFiles : [GTLRDrive_File] = filesList.files {
                     onCompleted(listOfFiles, error)
                 }
             }
         })
       }

    func uploadNote(note: Data, noteName: String, folderID: String?) {
        
        let file = GTLRDrive_File()
        file.name = noteName
       
        let params = GTLRUploadParameters(data: note, mimeType: MimeTypes.pdf.typeURL)
       params.shouldUploadWithSingleRequest = true
  
       let upload = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: params)
        
        driveService.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
            print(totalBytesUploaded / totalBytesExpectedToUpload)
        }
        
       self.driveService.executeQuery(upload, completionHandler:  { (response, result, error) in
           print(result)
           print(response)
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
}
