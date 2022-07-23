//
//  SelectColorPopoverViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 7/19/22.
//

import UIKit

class SelectColorPopoverViewController: UIViewController, UICollectionViewDelegate {

    private var colorcollectionView: ColorCollectionView?
    
    var returnColor: ((_ color: String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(view.bounds.height)
        colorcollectionView = ColorCollectionView(frame: .zero)
        colorcollectionView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorcollectionView!)
        colorcollectionView!.delegate = self
        
        colorcollectionView?.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        colorcollectionView?.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 10).isActive = true
        colorcollectionView?.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        colorcollectionView?.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor).isActive = true
        colorcollectionView?.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor).isActive = true
            
        colorcollectionView?.selectedColor = { color in
            
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
