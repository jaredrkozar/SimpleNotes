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

class GoogleInteractor: NSObject, GIDSignInDelegate, APIInteractor {

    var driveService = GTLRDriveService()
    var driveUser: GIDGoogleUser?
    var clientID: String = "968933311910-9e4an07ni7ugfji5i8t6cfkj18h1861m.apps.googleusercontent.com"
    var apiKey: String = "AIzaSyAJ9wzyhokME6E81kEmFqiQ4ceCswvAHdw"
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.driveService.authorizer = user.authentication.fetcherAuthorizer()
        self.driveUser = user
        printDD()
    }
    
    func handle(_ url: URL) -> Bool {
        print("DDDDD")
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func printDD() {
        print("DDDD")
        
    }
    func signIn(vc: UIViewController) {
        GIDSignIn.sharedInstance().clientID = clientID
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
        GIDSignIn.sharedInstance().delegate = vc as? GIDSignInDelegate
        GIDSignIn.sharedInstance()?.presentingViewController = vc
        if(GIDSignIn.sharedInstance().hasPreviousSignIn()) {
            GIDSignIn.sharedInstance().restorePreviousSignIn()
            print("sign in restored")
        } else {
            GIDSignIn.sharedInstance().signIn()
            print("new sign in")

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
                 if let listOfFolders : [GTLRDrive_File] = filesList.files {
                     onCompleted(listOfFolders, error)
                 }
             }
         })
       }
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().clientID = clientID
        if GIDSignIn.sharedInstance().currentUser != nil {
        self.driveService.authorizer = GIDSignIn.sharedInstance().currentUser.authentication.fetcherAuthorizer()
        }
        
    }
}
