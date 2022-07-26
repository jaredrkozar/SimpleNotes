//
//  ColorCollectionView.swift
//  SimpleNotes
//
//  Created by JaredKozar on 6/26/22.
//

import UIKit

class IconCollectionView: UICollectionView, UICollectionViewDelegate {

    let icons = [IconStruct(icon: "folder"), IconStruct(icon: "tray"), IconStruct(icon: "externaldrive"), IconStruct(icon: "doc"), IconStruct(icon: "doc.plaintext"), IconStruct(icon: "note.text"), IconStruct(icon: "book"), IconStruct(icon: "book.closed"), IconStruct(icon: "ticket"), IconStruct(icon: "link"), IconStruct(icon: "person"), IconStruct(icon: "person.crop.circle"), IconStruct(icon: "person.crop.square"), IconStruct(icon: "sun.max"), IconStruct(icon: "moon"), IconStruct(icon: "sunrise"), IconStruct(icon: "sunset"), IconStruct(icon: "umbrella"), IconStruct(icon: "thermometer"), IconStruct(icon: "cloud.moon"), IconStruct(icon: "mic"), IconStruct(icon: "loupe"), IconStruct(icon: "magnifyingglass"), IconStruct(icon: "square"), IconStruct(icon: "circle"), IconStruct(icon: "eye"), IconStruct(icon: "tshirt"), IconStruct(icon: "eyeglasses"), IconStruct(icon: "facemask"), IconStruct(icon: "message"), IconStruct(icon: "bubble.right"), IconStruct(icon: "quote.bubble"), IconStruct(icon: "star.bubble"), IconStruct(icon: "exclamationmark.bubble"), IconStruct(icon: "plus.bubble"), IconStruct(icon: "checkmark.bubble")]
    
    lazy var collectiondataSource = configureDataSource()
    
    private var collectionView: UICollectionView?
    
    var selectedIcon: ((_ icon: String)->())?
    
    init(frame: CGRect) {
        for icon in icons {
            if UIImage(systemName: icon.icon) != nil {
                print(icon.icon)
            } else {
                print("NIL")
            }
        }
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
    
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
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
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<IconSection, IconStruct> {
     
        let dataSource = UICollectionViewDiffableDataSource<IconSection, IconStruct>(collectionView: collectionView!) { (collectionView, indexPath, icon) -> ColorCollectionViewCell? in
     
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as! ColorCollectionViewCell
            cell.icon.image = UIImage(systemName: icon.icon)?.withTintColor(.systemBlue)
            cell.layer.cornerRadius = Constants.cornerRadius
            return cell
        }
     
        return dataSource
    }
    
    func applySnapshot() {
      
        var snapshot = NSDiffableDataSourceSnapshot<IconSection, IconStruct>()
          snapshot.appendSections([.main])
          snapshot.appendItems(icons, toSection: .main)
       
        collectiondataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIcon!(icons[indexPath.item].icon)
       
    }
}

struct IconStruct: Hashable {
    var icon: String!
    
    init(icon: String!) {
        self.icon = icon
    }
    
}

enum IconSection {
    case main
}
