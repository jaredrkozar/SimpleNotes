//
//  ColorCollectionView.swift
//  SimpleNotes
//
//  Created by JaredKozar on 6/26/22.
//

import UIKit

class ColorCollectionView: UICollectionView, UICollectionViewDelegate, UIColorPickerViewControllerDelegate {
    
    var colors: [ColorStruct] = [ColorStruct(color: UIColor.systemRed.toHex), ColorStruct(color: UIColor.systemOrange.toHex), ColorStruct(color: UIColor.systemYellow.toHex), ColorStruct(color: UIColor.systemGreen.toHex), ColorStruct(color: UIColor.systemBlue.toHex), ColorStruct(color: UIColor.systemIndigo.toHex), ColorStruct(color: UIColor.systemPurple.toHex), ColorStruct(color: UIColor.systemPink.toHex), ColorStruct(color: UIColor.systemMint.toHex), ColorStruct(color: UIColor.systemTeal.toHex), ColorStruct(color: UIColor.systemCyan.toHex), ColorStruct(color: UIColor.tertiarySystemBackground.toHex)]
    
    var allowTransparent: Bool?
    lazy var collectiondataSource = configureDataSource()
    
    private var collectionView: UICollectionView?
    
    var selectedColor: ((_ color: String)->())?
    
    init(frame: CGRect) {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
    
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        if allowTransparent == true  {
            colors.insert(ColorStruct(color: UIColor.secondarySystemBackground.toHex), at: 2)
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
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<ColorSection, ColorStruct> {
     
        let dataSource = UICollectionViewDiffableDataSource<ColorSection, ColorStruct>(collectionView: collectionView!) { (collectionView, indexPath, icon) -> ColorCollectionViewCell? in
     
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
      
        var snapshot = NSDiffableDataSourceSnapshot<ColorSection, ColorStruct>()
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
            colors.insert(ColorStruct(color: viewController.selectedColor.toHex), at: colors.count - 1)
            applySnapshot()
        }

    }
}

struct ColorStruct: Hashable {
    var color: String!
    
    init(color: String!) {
        self.color = color
    }
    
}

enum ColorSection {
    case main
}
