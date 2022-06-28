//
//  TintPickerViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/22/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class TintPickerViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tint Picker"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        let colorcollectionView = ColorCollectionView(frame: CGRect(x: 20, y: 30, width: 400, height: 400))
        view.addSubview(colorcollectionView)
        // Register cell classes

        // Do any additional setup after loading the view.
    }

}
