//
//  TableRowCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/15/22.
//

import UIKit

protocol TableRowCellDelegate: AnyObject {
    func buttonTapped(num: Int)
}

class TableRowCell: UITableViewCell {

    weak var delegate: TableRowCellDelegate?
    
    @IBOutlet var background: UIView!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var logOutButton: CustomButton!
    var cellIndex: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        delegate?.buttonTapped(num: cellIndex!.row)
    }
}
