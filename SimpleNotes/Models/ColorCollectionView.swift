//
//  ColorCollectionView.swift
//  SimpleNotes
//
//  Created by JaredKozar on 6/26/22.
//

import UIKit

class ColorCollectionView: UICollectionView, UICollectionViewDelegate, UIColorPickerViewControllerDelegate {
    
    var colors: [Color] = [Color(color: UIColor.systemRed.toHex), Color(color: UIColor.systemOrange.toHex), Color(color: UIColor.systemYellow.toHex), Color(color: UIColor.systemGreen.toHex), Color(color: UIColor.systemBlue.toHex), Color(color: UIColor.systemIndigo.toHex), Color(color: UIColor.systemPurple.toHex), Color(color: UIColor.systemPink.toHex), Color(color: UIColor.systemMint.toHex), Color(color: UIColor.systemTeal.toHex), Color(color: UIColor.systemCyan.toHex), Color(color: UIColor.tertiarySystemBackground.toHex)]
    
    var allowTransparent: Bool?
    lazy var collectiondataSource = configureDataSource()
    
    private var collectionView: UICollectionView?
    
    var selectedColor: ((_ color: String)->())?
    
    init(frame: CGRect) {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
    
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        if allowTransparent == true  {
            colors.insert(Color(color: UIColor.secondarySystemBackground.toHex), at: 2)
        }
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        self.addSubview(collectionView!)
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView?.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        applySnapshot()
        collectionView?.dataSource = collectiondataSource
        collectionView?.delegate = self
        collectionView?.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<ColorSection, Color> {
     
        let dataSource = UICollectionViewDiffableDataSource<ColorSection, Color>(collectionView: collectionView!) { (collectionView, indexPath, icon) -> ColorCollectionViewCell? in
     
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as! ColorCollectionViewCell
            cell.backgroundColor = UIColor(hex: self.colors[indexPath.item].color)
            cell.icon.image = UIImage(systemName: "pin")
            cell.layer.cornerRadius = Constants.cornerRadius
            
            if indexPath.item == self.colors.count - 1 {
                let image = UIImageView()
                image.frame = CGRect(x: 2, y: 2, width: cell.contentView.bounds.width - 5, height: cell.contentView.bounds.height - 5)
                image.image = UIImage(systemName: "plus")
                cell.addSubview(image)
            }
            return cell
        }
     
        return dataSource
    }
    
    func applySnapshot() {
      
        var snapshot = NSDiffableDataSourceSnapshot<ColorSection, Color>()
          snapshot.appendSections([.main])
          snapshot.appendItems(colors, toSection: .main)
       
        collectiondataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == colors.count - 1 {
            let colorPicker = UIColorPickerViewController()
            colorPicker.supportsAlpha = false
            colorPicker.delegate = self
            self.findViewController()?.present(colorPicker, animated: true)
        } else {
            selectedColor?((colors[indexPath.item].color ?? UIColor.systemBlue.toHex)!)
        }
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        if continuously == false {
            colors.insert(Color(color: viewController.selectedColor.toHex), at: colors.count - 1)
            applySnapshot()
        }

    }
}

struct Color: Hashable {
    var color: String!
    
    init(color: String!) {
        self.color = color
    }
    
}

enum ColorSection {
    case main
}
