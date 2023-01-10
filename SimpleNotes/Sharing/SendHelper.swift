//
//  SharingNote.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/9/22.
//

import Foundation
import MessageUI

class SendHelper: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = SendHelper()
    
    func sendEmail(title: String, noteData: Data?){
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject(title)
            
            if noteData != nil {
                mail.addAttachmentData(noteData!, mimeType: "application/pdf", fileName: "\(title).pdf")
            }
            
            getRootViewController()?.present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
    func sendText(noteTitle: String, notePDF: Data?) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let message = MFMessageComposeViewController()

            message.body = "Title: \(noteTitle)"
            
            if notePDF != nil {
                message.addAttachmentData(notePDF!, typeIdentifier: "application/pdf", filename: "\(noteTitle).pdf")
            }
            
            getRootViewController()?.present(message, animated: true, completion: nil)
        }
    }
    
    func sendToOtherApp(noteTitle: String, notePDF: [Any]) {
        
        let ac = UIActivityViewController(activityItems: notePDF, applicationActivities: nil)
        getRootViewController()?.present(ac, animated: true, completion: nil)
    }
}
