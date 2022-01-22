//
//  SignInProtocol.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/11/22.
//

import UIKit

protocol APIInteractor {
    
    func signIn(vc: UIViewController)
    
    var isSignedIn: Bool { get }
    
    func signOut()
    
    func fetchFiles(folderID: String?, onCompleted: @escaping ([CloudServiceFiles]?, Error?) -> ())
    
    func uploadFile(note: Data, noteName: String, folderID: String?)
    
    func getFileType(type: String) -> String
}
