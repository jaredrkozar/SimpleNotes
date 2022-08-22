//
//  SelectColorPopoverViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 7/19/22.
//

import UIKit

class SelectColorPopoverViewController: UIViewController, UICollectionViewDelegate {

    var colorcollectionView =  ColorCollectionView(frame: .zero)
    var displayTransparent: Bool = false
    
    var returnColor: ((_ color: String)->())?
    var vcTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = vcTitle
        self.view.backgroundColor = .green
        colorcollectionView = ColorCollectionView(frame: .zero)
        colorcollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorcollectionView.allowTransparent = displayTransparent
        view.addSubview(colorcollectionView)
        colorcollectionView.delegate = self
        
        colorcollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10 ).isActive = true
        colorcollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        colorcollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        colorcollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
        colorcollectionView.selectedColor = { color in
            
            self.returnColor?(color)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
