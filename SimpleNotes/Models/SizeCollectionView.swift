//
//  ColorCollectionView.swift
//  SimpleNotes
//
//  Created by JaredKozar on 6/26/22.
//

import UIKit

class SizeCollectionView: UICollectionView, UICollectionViewDelegate {
    
    var widths: [Size] = [Size(width: 1.0), Size(width: 3.0), Size(width: 5.0), Size(width: 7.0), Size(width: 10.0), Size(width: 13.0), Size(width: 15.0), Size(width: 17.0), Size(width: 21.0), Size(width: 25.0), Size(width: 27.0), Size(width: 30.0)]
    
    lazy var collectiondataSource = configureDataSource()
    
    private var collectionView: UICollectionView?
    
    var selectedWidth: ((_ width: Double)->())?
    
    init(frame: CGRect) {
        
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
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<SIzeSection, Size> {
     
        let dataSource = UICollectionViewDiffableDataSource<SIzeSection, Size>(collectionView: collectionView!) { (collectionView, indexPath, icon) -> ColorCollectionViewCell? in
     
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as! ColorCollectionViewCell
            cell.backgroundColor = .systemGray5
            let circle = CAShapeLayer()
            circle.path = UIBezierPath(arcCenter: cell.contentView.center, radius: self.widths[indexPath.item].width * 0.75, startAngle: 0.0, endAngle: .pi * 2, clockwise: true).cgPath
            circle.fillColor = UIColor.label.cgColor
            cell.layer.addSublayer(circle)
            cell.layer.cornerRadius = Constants.cornerRadius
            return cell
        }
     
        return dataSource
    }
    
    func applySnapshot() {
      
        var snapshot = NSDiffableDataSourceSnapshot<SIzeSection, Size>()
          snapshot.appendSections([.main])
          snapshot.appendItems(widths, toSection: .main)
       
        collectiondataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedWidth?(widths[indexPath.item].width)
    }
}

struct Size: Hashable {
    var width: Double!
    
    init(width: Double!) {
        self.width = width
    }
    
}

enum SIzeSection {
    case main
}
