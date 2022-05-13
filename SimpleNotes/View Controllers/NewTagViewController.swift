//
//  NewTagViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/20/21.
//

import UIKit

class NewTagViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIColorPickerViewControllerDelegate {
    let detailIcons = UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular, scale: .large)
    
    @IBOutlet var tagNameField: UITextField!
    @IBOutlet var symbolImage: UIImageView!
    
    @IBOutlet var colorCollectionView: UICollectionView!
    @IBOutlet var iconCOllectionView: UICollectionView!
    var currentTag: AllTags?
    var colorCell = "colorCell"
    var iconCell = "iconCell"
    
    var image: String?
    var selectedColor: UIColor?
    var name: String?

    var isEditingTag: Bool?
    
    let colors = [UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemCyan, UIColor.systemPurple, UIColor.systemIndigo, UIColor.systemPink, UIColor.systemGray5]
      let icons = ["folder", "tray", "externaldrive", "doc", "doc.plaintext", "note.text", "book", "book.closed", "ticket", "link", "person", "person.crop.circle", "person.crop.square", "sun.max", "moon", "umbrella", "thermometer", "cloud.moon", "mic", "loupe", "magnifyingglass", "square", "circle", "eye", "tshirt", "eyeglasses", "facemask", "message", "bubble.right", "quote.bubble", "star.bubble", "exclamationmark.bubble", "plus.bubble", "checkmark.bubble"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let colorCell = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
        colorCollectionView.register(colorCell, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        iconCOllectionView.register(colorCell, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        
        colorCollectionView.allowsSelection = true
        colorCollectionView.allowsMultipleSelection = false
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        iconCOllectionView.allowsSelection = true
        iconCOllectionView.allowsMultipleSelection = false
        iconCOllectionView.delegate = self
        iconCOllectionView.dataSource = self
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        self.navigationItem.rightBarButtonItems = [doneButton]
        
        self.navigationItem.leftBarButtonItems = [cancelButton]
        
        tagNameField.text = name
        symbolImage.image = sendBackSymbol(imageName: image ?? "folder", color: selectedColor ?? UIColor.systemBlue)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView==colorCollectionView) {
            return colors.count
        } else {
            return icons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView==colorCollectionView) {
            var cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
            cell.layer.cornerRadius = 12.0
            cell.backgroundColor = colors[indexPath.item]
            
            if indexPath.item == colors.count - 1 {
                cell.icon.image = UIImage(systemName: "plus", withConfiguration: detailIcons)
                cell.icon.tintColor = .label
            }
            return cell
        } else {
            let cell = iconCOllectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
            cell.layer.cornerRadius = 9.0
            cell.backgroundColor = .green
            cell.icon.image = UIImage(systemName: icons[indexPath.item], withConfiguration: detailIcons)
            cell.icon.tintColor = selectedColor
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView==colorCollectionView) {
  
            if indexPath.item != colors.count - 1 {
                if let cell = colorCollectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                    cell.layer.borderColor = colors[indexPath.item].darker(by: 40.0)?.cgColor
                    cell.layer.borderWidth = 5.0
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
            
            
                      if let cell = iconCOllectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                          cell.layer.borderColor = UIColor.gray.cgColor
                          cell.layer.borderWidth = 5.0
                          }
            
          let iconcell = iconCOllectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            image = icons[indexPath.item] as! String
        }
    
        symbolImage.image = sendBackSymbol(imageName: (image ?? "folder"), color: selectedColor ?? UIColor.systemGray)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(collectionView==colorCollectionView){
  
            if let cell = colorCollectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                
                cell.layer.borderWidth = 0.0
                }
        } else {
            
            if let cell = iconCOllectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                
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
    }
    
}
