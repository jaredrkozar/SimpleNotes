//
//  SharingNote.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/9/22.
//

import UIKit
import MessageUI

extension NoteShareSettingsViewController: MFMailComposeViewControllerDelegate {

    func sendEmail(noteTitle: String, noteText: String?, noteDate: String?, notePDF: Data?) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject(noteTitle)
            if noteText != nil {
                mail.setMessageBody("<h2>\(noteTitle)</h2> <br> <h4>Created on \(noteDate!)</h4> <br> <h4> \(noteText!)</h4>", isHTML: true)
            }
            
            if notePDF != nil {
                mail.addAttachmentData(notePDF!, mimeType: "application/pdf", fileName: "\(noteTitle).pdf")
            }
            
            self.present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
