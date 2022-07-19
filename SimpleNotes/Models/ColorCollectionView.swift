//
//  ColorCollectionView.swift
//  SimpleNotes
//
//  Created by JaredKozar on 6/26/22.
//

import UIKit

class ColorCollectionView: UICollectionView, UICollectionViewDelegate {

    var colors: [Color] = [Color(color: UIColor.systemRed.toHex), Color(color: UIColor.systemGreen.toHex), Color(color: UIColor.systemBlue.toHex), Color(color: UIColor.systemCyan.toHex), Color(color: UIColor.systemPink.toHex), Color(color: UIColor.systemOrange.toHex), Color(color: UIColor.systemMint.toHex), Color(color: UIColor.systemIndigo.toHex), Color(color: UIColor.systemTeal.toHex), Color(color: UIColor.systemYellow.toHex), Color(color: UIColor.systemPurple.toHex)]
    
    lazy var collectiondataSource = configureDataSource()
    
    private var collectionView: UICollectionView?
    
    var selectedColor: ((_ color: String)->())?
    
    init(frame: CGRect) {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.addSubview(collectionView!)
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
            cell.layer.cornerRadius = Constants.cornerRadius
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
        selectedColor?((colors[indexPath.item].color ?? UIColor.systemBlue.toHex)!)
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
