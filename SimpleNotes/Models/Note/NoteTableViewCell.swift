//
//  NoteTableViewCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/8/21.
//

import UIKit
import WSTagsField

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteThumbanil: UIImageView!
    @IBOutlet var noteTitle: UILabel!
    @IBOutlet var noteDate: UILabel!
    
    var tagView: TagView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
        tagView = TagView(frame: CGRect(x: 173, y: 105, width: contentView.bounds.maxX - 173 - 50, height: 75))
        
        self.addSubview(tagView!)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
