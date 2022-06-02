//
//  TableRowCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/15/22.
//

import UIKit

protocol TableRowCellDelegate: AnyObject {
    func buttonTapped(cell: TableRowCell, num: Int?)
}

class TableRowCell: UITableViewCell {

    weak var delegate: TableRowCellDelegate?
    
    static let identifier = "TableRowCell"
    
    var bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.frame = CGRect(x: 15, y: 13, width: 40, height: 40)
        return view
    }()
    
    var iconView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 3, y: 5, width: 35, height: 30)
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.frame = CGRect(x: 60, y: 15, width: 130, height: 40)
        return label
    }()
    
    var cellIndex: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        contentView.addSubview(bgView)
        bgView.addSubview(iconView)
        contentView.addSubview(titleLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        delegate?.buttonTapped(cell: self, num: cellIndex!.row)
    }
    
    func configureCell(with model: SettingsOptions) {
        iconView.image = model.icon
        bgView.backgroundColor = model.iconBGColor
        titleLabel.text = model.title
        
        switch model.detailViewType {
        case .control(controls: let controls):
            for control in controls {
                control.frame = CGRect(x: contentView.bounds.maxX - control.bounds.width + 20, y: 5, width: control.bounds.width, height: control.bounds.height)
                contentView.addSubview(control)
            }
        case .color(color: let color):
            let view = UIView()
            view.frame = CGRect(x: contentView.bounds.maxX - 20, y: 5, width: 10, height: 10)
            view.backgroundColor = color
            contentView.addSubview(view)
        case .text(string: let string):
            let label = UILabel()
            label.text = string
            label.frame = CGRect(x: contentView.bounds.maxX - 40, y: contentView.bounds.maxY / 2, width: 10, height: 10)
            contentView.addSubview(label)
        case .none:
            print("No control")
        }
    }
}
