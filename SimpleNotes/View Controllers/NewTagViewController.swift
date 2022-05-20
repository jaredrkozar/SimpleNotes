//
//  NewTagViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/20/21.
//

import UIKit

class NewTagViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIColorPickerViewControllerDelegate {
    let detailIcons = UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular, scale: .large)
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tagNameField: UITextField!
    @IBOutlet var symbolImage: UIImageView!
    
    @IBOutlet var collectionView: UICollectionView!
    var currentTag: AllTags?
    var colorCell = "colorCell"
    var iconCell = "iconCell"
    
    var image: String?
    var selectedColor: UIColor?
    var name: String?

    var isEditingTag: Bool?
    
    var colors = [UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemCyan, UIColor.systemPurple, UIColor.systemIndigo, UIColor.systemPink, UIColor.systemGray5]
      let icons = ["folder", "tray", "externaldrive", "doc", "doc.plaintext", "note.text", "book", "book.closed", "ticket", "link", "person", "person.crop.circle", "person.crop.square", "sun.max", "moon", "umbrella", "thermometer", "cloud.moon", "mic", "loupe", "magnifyingglass", "square", "circle", "eye", "tshirt", "eyeglasses", "facemask", "message", "bubble.right", "quote.bubble", "star.bubble", "exclamationmark.bubble", "plus.bubble", "checkmark.bubble"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let colorCell = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
        collectionView.register(colorCell, forCellWithReuseIdentifier: "colorCell")
        segmentedControl.selectedSegmentIndex = 0
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        self.navigationItem.rightBarButtonItems = [doneButton]
        
        self.navigationItem.leftBarButtonItems = [cancelButton]
        
        tagNameField.text = name
        symbolImage.image = sendBackSymbol(imageName: image ?? "folder", color: selectedColor ?? UIColor.systemBlue)
    }
    
    @IBAction func changedSegment(_ sender: UISegmentedControl) {
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(segmentedControl.selectedSegmentIndex==0) {
            return colors.count
        } else {
            return icons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
        cell.layer.cornerRadius = Constants.cornerRadius
        switch segmentedControl.selectedSegmentIndex {
            case 0:
        
                cell.backgroundColor = colors[indexPath.item]
            cell.icon.image = nil
            
            case 1:
            
            cell.backgroundColor = .systemGray5
            
                cell.icon.image = UIImage(systemName: icons[indexPath.item], withConfiguration: detailIcons)
                cell.icon.tintColor = selectedColor
        
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(segmentedControl.selectedSegmentIndex==0) {
  
            if indexPath.item != colors.count - 1 {
                if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                    cell.layer.borderColor = colors[indexPath.item].darker(by: 40.0)?.cgColor
                    cell.layer.borderWidth = Constants.borderWidth
                    }
                
                selectedColor = colors[indexPath.item] as! UIColor
            } else {
                let colorPicker = UIColorPickerViewController()
                colorPicker.selectedColor = selectedColor!
                colorPicker.supportsAlpha = false
                colorPicker.delegate = self
                colorPicker.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pin"), style: .done, target: nil, action: nil)
                present(colorPicker, animated: true)
            }
        } else {
            
            
                      if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                          cell.layer.borderColor = UIColor.gray.cgColor
                          cell.layer.borderWidth = Constants.borderWidth
                          }
            
          let iconcell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            image = icons[indexPath.item] as! String
        }
    
        symbolImage.image = sendBackSymbol(imageName: (image ?? "folder"), color: selectedColor ?? UIColor.systemGray)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(segmentedControl.selectedSegmentIndex==0){
            if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                
                cell.layer.borderWidth = 0.0
                }
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                
                cell.layer.borderWidth = 0.0
            }
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as? CollectionReusableView
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionReusableView.identifier, for: indexPath) as! CollectionReusableView
            
            if indexPath.section == 1 {
                header.label.text = " Dark icons"
            } else {
                header.label.text = " Light icons"
            }
        
        return header
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        
        selectedColor = color
        
        symbolImage.image = sendBackSymbol(imageName: (image ?? "folder"), color: selectedColor!)
        
        if continuously == false {
            
            colors.insert(selectedColor!, at: colors.count - 1)
            collectionView.reloadData()
        }
    }
    
}
