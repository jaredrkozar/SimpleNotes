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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    var cellIndex: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code\
        
    }
    
    override func layoutSubviews() {
        contentView.addSubview(bgView)
        bgView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        
        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: iconView.image != nil ? 70 : 30),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        delegate?.buttonTapped(cell: self, num: cellIndex!.row)
    }
    
    func configureCell(with model: SettingsOptions) {
        iconView.image = model.rowIcon?.icon
        iconView.tintColor = model.rowIcon?.iconTintColor ?? UIColor.white
        bgView.backgroundColor = model.rowIcon?.iconBGColor
        titleLabel.text = model.title
        
        switch model.control {
        case .control(controls: let controls):
            optionLabel.isHidden = true
            for control in controls {
                control.sizeToFit()
                control.frame = CGRect(x: contentView.bounds.maxX - control.bounds.width + 20, y: 5, width: control.bounds.width, height: control.bounds.height)
                control.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(control)
                
                let constraints = [
                    control.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                    control.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    control.widthAnchor.constraint(equalToConstant: 100),
                    control.heightAnchor.constraint(equalToConstant: 30)
                ]
                
                NSLayoutConstraint.activate(constraints)
            }
        case .color(color: let view):
            optionLabel.isHidden = true
            contentView.addSubview(view)
    
            let constraints = [
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                view.widthAnchor.constraint(equalToConstant: 30),
                view.heightAnchor.constraint(equalToConstant: 30)
            ]
            
            NSLayoutConstraint.activate(constraints)
        case .text(string: let string):
            optionLabel.text = string
            contentView.addSubview(optionLabel)
            
            let constraints = [
                optionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                optionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                optionLabel.widthAnchor.constraint(equalToConstant: 400),
                optionLabel.heightAnchor.constraint(equalToConstant: 30)
            ]
            
            NSLayoutConstraint.activate(constraints)
        case .none:
            return
        }
    }
    
    @objc func fieldTectChanged() {
        print("CHNAGED")
    }
}
