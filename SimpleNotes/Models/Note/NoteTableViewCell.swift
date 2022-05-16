//
//  NoteTableViewCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/8/21.
//

import UIKit
import WSTagsField

class NoteTableViewCell: UITableViewCell {

    @IBOutlet var noteTitle: UILabel!
    @IBOutlet var noteDate: UILabel!
    @IBOutlet var noteText: UITextView!
    @IBOutlet var noteTags: WSTagsField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        noteTags.tintColor = UIColor(named: "AccentColor")
        noteTags.cornerRadius = 6.0
        noteTags.spaceBetweenTags = 3.0
        noteTags.readOnly = true
        noteTags.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        noteTags.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        noteTags.numberOfLines = 1
        
        noteTags.backgroundColor = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
