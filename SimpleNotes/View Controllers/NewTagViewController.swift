//
//  NewTagViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/20/21.
//

import UIKit

class NewTagViewController: UIViewController, UICollectionViewDelegate, UIColorPickerViewControllerDelegate {
    let detailIcons = UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular, scale: .large)
    
    var segmentedControl = UISegmentedControl(items: ["Color", "Icon"])
    var tagNameField = UITextField()
    var symbolImage = UIImageView()
    
    var currentTag: AllTags?
    var colorCell = "colorCell"
    var iconCell = "iconCell"
    
    var image: String?
    var selectedColor: UIColor?
    var name: String?

    var isEditingTag: Bool?
    
    private var colorcollectionView: ColorCollectionView?
    
    private var iconcollectionView: IconCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        segmentedControl.addTarget(self, action: #selector(segmentValueChanged(sender:)), for: .valueChanged)
                
        segmentedControl.selectedSegmentIndex = 0
        tagNameField.text = currentTag?.name
        tagNameField.backgroundColor = .systemGray4
        tagNameField.layer.cornerRadius = Constants.cornerRadius
        
        tagNameField.translatesAutoresizingMaskIntoConstraints = false
        symbolImage.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(segmentedControl)
        view.addSubview(symbolImage)
        view.addSubview(tagNameField)
        
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: tagNameField.bottomAnchor, constant: 20).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        symbolImage.contentMode = .scaleAspectFit
        symbolImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        symbolImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        symbolImage.widthAnchor.constraint(equalTo: symbolImage.heightAnchor, multiplier: 1).isActive = true
        symbolImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        tagNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        tagNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        tagNameField.topAnchor.constraint(equalTo: symbolImage.bottomAnchor, constant: 20).isActive = true
        tagNameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tagNameField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        colorcollectionView = ColorCollectionView(frame: .zero)
        iconcollectionView = IconCollectionView(frame: .zero)
    
        colorcollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        colorcollectionView!.delegate = self
        
        iconcollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        iconcollectionView!.delegate = self
        
        self.view.addSubview(colorcollectionView!)
        
        colorcollectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        colorcollectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5).isActive = true
        colorcollectionView?.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
        colorcollectionView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
        self.view.addSubview(iconcollectionView!)
        iconcollectionView?.leadingAnchor.constraint(equalTo: colorcollectionView!.leadingAnchor, constant: 0).isActive = true
        iconcollectionView?.trailingAnchor.constraint(equalTo: colorcollectionView!.trailingAnchor, constant: 5).isActive = true
        iconcollectionView?.topAnchor.constraint(equalTo: colorcollectionView!.topAnchor, constant: 20).isActive = true
        iconcollectionView?.bottomAnchor.constraint(equalTo: colorcollectionView!.bottomAnchor).isActive = true
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        self.navigationItem.rightBarButtonItems = [doneButton]
        
        self.navigationItem.leftBarButtonItems = [cancelButton]
        
        tagNameField.text = name
        symbolImage.image = sendBackSymbol(imageName: image ?? "folder", color: selectedColor ?? UIColor.systemBlue)
        
        colorcollectionView?.selectedColor = { color in
            
            self.selectedColor = UIColor(hex: color)
            
            self.changeIcon(iconName: self.image ?? "folder", color: self.selectedColor!)
        }
        
        iconcollectionView?.selectedIcon = { icon in
            
            self.image = icon
            
            self.changeIcon(iconName: icon, color: self.selectedColor ?? .systemBlue)
        }
    }
    
    func changeIcon(iconName: String, color: UIColor) {
        self.symbolImage.image = sendBackSymbol(imageName: iconName, color: selectedColor!)
    }
    
    @objc func segmentValueChanged(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            iconcollectionView?.isHidden = true
            colorcollectionView?.isHidden = false
        } else {
            iconcollectionView?.isHidden = false
            colorcollectionView?.isHidden = true
        }
    }
    
    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) {
       
        if isEditingTag == true {
            saveTag(currentTag: currentTag, name: tagNameField.text!, symbol: image!, color: (selectedColor?.toHex)!)
        } else {
            
            saveTag(currentTag: nil, name: tagNameField.text!, symbol: image ?? "folder", color: (selectedColor?.toHex)!)
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
}
