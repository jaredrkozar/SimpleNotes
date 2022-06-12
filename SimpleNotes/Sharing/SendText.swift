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
    
    
    func sendText(noteTitle: String, noteText: String?, noteDate: String?, notePDF: Data?) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let message = MFMessageComposeViewController()
            message.messageComposeDelegate = self

            if noteText != nil {
                message.body = "Title: \(noteTitle) Created on \(noteDate!) TextL \(noteText!)"
            }
            
            if notePDF != nil {
                message.addAttachmentData(notePDF!, typeIdentifier: "application/pdf", filename: "\(noteTitle).pdf")
            }
            
            self.present(message, animated: true, completion: nil)
        }
    }
}
