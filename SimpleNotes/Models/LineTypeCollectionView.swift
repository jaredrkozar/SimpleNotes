//
//  ColorCollectionView.swift
//  SimpleNotes
//
//  Created by JaredKozar on 6/26/22.
//

import UIKit

class LineTypeCollectionView: UICollectionView, UICollectionViewDelegate {

    let strokes = [StrokeStruct(strokeType: .normal), StrokeStruct(strokeType: .dashed), StrokeStruct(strokeType: .dotted)]
    
    lazy var collectiondataSource = configureDataSource()
    
    private var collectionView: UICollectionView?
    
    var selectedStroke: ((_ strokeType: Int)->())?
    
    init(frame: CGRect) {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 50)
    
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
        collectionView?.register(LineTypeCollectionViewCell.self, forCellWithReuseIdentifier: LineTypeCollectionViewCell.identifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<StrokeSection, StrokeStruct> {
     
        let dataSource = UICollectionViewDiffableDataSource<StrokeSection, StrokeStruct>(collectionView: collectionView!) { (collectionView, indexPath, icon) -> LineTypeCollectionViewCell? in
     
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LineTypeCollectionViewCell.identifier, for: indexPath) as! LineTypeCollectionViewCell
            cell.backgroundColor = .systemGray5
            cell.lineType = self.strokes[indexPath.item].strokeType
            return cell
        }
     
        return dataSource
    }
    
    func applySnapshot() {
      
        var snapshot = NSDiffableDataSourceSnapshot<StrokeSection, StrokeStruct>()
          snapshot.appendSections([.main])
          snapshot.appendItems(strokes, toSection: .main)
       
        collectiondataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedStroke!(strokes[indexPath.item].strokeType.rawValue)
       
    }
}

struct StrokeStruct: Hashable {
    var strokeType: StrokeTypes!
    
    init(strokeType: StrokeTypes!) {
        self.strokeType = strokeType
    }
    
}

enum StrokeSection {
    case main
}
