//
//  ToolOptionsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/11/22.
//

import UIKit

class ToolOptionsViewController: UIViewController, UICollectionViewDelegate {
    
    var drawingview: DrawingView?

    private var colorcollectionView: ColorCollectionView?
    private var sizecollectionview: SizeCollectionView?
    private var linetypecollectionview: LineTypeCollectionView?
    
    override func viewDidLoad() {
        
        title = "ppl Settings"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .done, target: self, action: #selector(toggleFavoriteTool))

        colorcollectionView = ColorCollectionView(frame: .zero)
        sizecollectionview = SizeCollectionView(frame: .zero)
        linetypecollectionview = LineTypeCollectionView(frame: .zero)
        
        view.addSubview(colorcollectionView!)
        view.addSubview(sizecollectionview!)
        view.addSubview(linetypecollectionview!)
        
        colorcollectionView?.translatesAutoresizingMaskIntoConstraints = false
        sizecollectionview?.translatesAutoresizingMaskIntoConstraints = false
        linetypecollectionview?.translatesAutoresizingMaskIntoConstraints = false
        colorcollectionView!.delegate = self
        sizecollectionview!.delegate = self
        linetypecollectionview!.delegate = self
        
        colorcollectionView?.leadingAnchor.constraint(equalTo:view.readableContentGuide.leadingAnchor).isActive = true
        colorcollectionView?.trailingAnchor.constraint(equalTo: currentDevice == .iphone ? view.readableContentGuide.trailingAnchor : view.centerXAnchor).isActive = true
        colorcollectionView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        colorcollectionView?.bottomAnchor.constraint(equalTo: currentDevice == .iphone ? sizecollectionview!.topAnchor : view.lastBaselineAnchor, constant: -50).isActive = true
        colorcollectionView?.heightAnchor.constraint(equalToConstant: 125).isActive = true
        
        sizecollectionview?.leadingAnchor.constraint(equalTo: currentDevice == .iphone ? view.readableContentGuide.leadingAnchor : colorcollectionView!.trailingAnchor).isActive = true
        sizecollectionview?.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).isActive = true
        sizecollectionview?.topAnchor.constraint(equalTo: currentDevice == .iphone ? colorcollectionView!.bottomAnchor : view.safeAreaLayoutGuide.topAnchor).isActive = true
        sizecollectionview?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sizecollectionview?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        linetypecollectionview?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        linetypecollectionview?.trailingAnchor.constraint(equalTo: currentDevice == .iphone ? view.safeAreaLayoutGuide.trailingAnchor : view.centerXAnchor).isActive = true
        linetypecollectionview?.topAnchor.constraint(equalTo: currentDevice == .iphone ? sizecollectionview!.bottomAnchor : colorcollectionView!.bottomAnchor, constant: -15 ).isActive = true
        linetypecollectionview?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        colorcollectionView?.selectedColor = { color in
            
            UserDefaults.standard.set(color, forKey: "color")
            NotificationCenter.default.post(name: Notification.Name( "changedColor"), object: nil)
        }
        
        sizecollectionview?.selectedWidth = { width in
            
            UserDefaults.standard.set(width, forKey: "width")
            NotificationCenter.default.post(name: Notification.Name( "changedWidth"), object: nil)
        }
        
        linetypecollectionview?.selectedStroke = { strokeType in
            
            UserDefaults.standard.set(strokeType, forKey: "strokeType")
            NotificationCenter.default.post(name: Notification.Name( "changedStrokeType"), object: nil)
        }
    }
    
    @objc func toggleFavoriteTool(sender: UIBarButtonItem) {
        
        sender.image = UIImage(systemName: "star.fill")
    }
}
