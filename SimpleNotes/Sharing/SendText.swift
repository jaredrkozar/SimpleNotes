//
//  SendText.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/9/22.
//

import UIKit
import MessageUI

extension NoteShareSettingsViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func sendText(noteTitle: String, notePDF: Data?) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let message = MFMessageComposeViewController()
            message.messageComposeDelegate = self

            message.body = "Title: \(noteTitle)"
            
            if notePDF != nil {
                message.addAttachmentData(notePDF!, typeIdentifier: "application/pdf", filename: "\(noteTitle).pdf")
            }
            
            self.present(message, animated: true, completion: nil)
        }
    }
}
