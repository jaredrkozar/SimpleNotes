//
//  NewNoteViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/19/21.
//

import UIKit
import WSTagsField
import PhotosUI

class NoteViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    @IBOutlet var noteTitleField: UITextField!
    @IBOutlet var noteDateField: UIDatePicker!
    @IBOutlet var noteTagsField: WSTagsField!
    @IBOutlet var drawingVIew: DrawingView!
    
    var isNoteLocked: Bool?
    var timer: Timer?
    
    var currentNote: Note?
    
    var textBoxes = [CustomTextBox]()
    
    var moreButton: UIBarButtonItem?
    
    var listOfTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ToastNotification().showToast(backgroundColor: .systemBlue, image: UIImage(systemName: "pin")!, titleText: "DDDD", subtitleText: nil, progress: 4.0)
        
        // Do any additional setup after loading the view.
        drawingVIew.setup()
        drawingVIew.tool = .pen
        drawingVIew.currentPen = PenTool(width: 20.0, color: .systemPink, opacity: 1.0, blendMode: .normal, strokeType: .normal)
        
        drawingVIew.currentHighlighter = PenTool(width: 20.0, color: .systemYellow, opacity: 0.6, blendMode: .normal, strokeType: .normal)
    
        noteTitleField.backgroundColor = UIColor.systemGray5
        noteTitleField.layer.cornerRadius = 6.0
        noteTitleField.text = currentNote?.title ?? ""
        
        noteTagsField.cornerRadius = 6.0
        noteTagsField.spaceBetweenTags = 3.0
        noteTagsField.numberOfLines = 2
        
        noteTagsField.readOnly = true
        noteTagsField.addTags((currentNote?.tags?.map({"\(String(describing: ($0 as AnyObject).name!))"})) ?? [String]())
        
        if #available(iOS 16.0, *) {
            self.navigationItem.style = .editor
            self.navigationItem.title = "DLLDLDLD"
            
            navigationItem.centerItemGroups =
            [
            UIBarButtonItem(image: UIImage(named: "penIcon"), style: .plain, target: self, action: #selector(penTool(_:))).creatingMovableGroup(customizationIdentifier: "pen"),
            
            UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(presentPhotoPicker(_:))).creatingMovableGroup(customizationIdentifier: "photo"),
            
            UIBarButtonItem(image: UIImage(named: "penIcon"), style: .plain, target: self, action: #selector(penTool(_:))).creatingMovableGroup(customizationIdentifier: "pen"),
            
            UIBarButtonItemGroup.optionalGroup(customizationIdentifier: "shapes", items: [
                
                UIBarButtonItem(image: UIImage(systemName: "square"), style: .plain, target: .none, action: #selector(printLetter)),
                
                UIBarButtonItem(image: UIImage(systemName: "circle"), style: .plain, target: .none, action: #selector(printLetter))

            ])]
            
            navigationItem.renameDelegate = self
            navigationItem.titleMenuProvider = { suggestedActions in
                
                var children = suggestedActions
                children += [
                
                    UIAction(title: "Edit Tags", subtitle: "\(self.currentNote?.tags?.count ?? 0) tags", image: UIImage(systemName: "pin"), identifier: .none, discoverabilityTitle: "String? = nil",  attributes: [], state: .off) { _ in
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editTagsVC") as! EditTagsTableViewController
                        let navController = UINavigationController(rootViewController: vc)
                        vc.note = self.currentNote
                        
                        switch currentDevice {
                        case .iphone:
                            self.present(navController, animated: true, completion: nil)
                        case .ipad, .mac:
                            navController.modalPresentationStyle = UIModalPresentationStyle.popover
                            navController.preferredContentSize = CGSize(width: 375, height: 300)
                            navController.popoverPresentationController?.sourceView = self.view
                            self.present(navController, animated: true, completion: nil)
                        case .none:
                            return
                        }
                    },
                    
                    UIAction(title: self.currentNote?.isLocked ?? false ? "Unlock Note" : "Lock Note", subtitle: "", image: self.currentNote?.isLocked ?? false ? UIImage(systemName: "lock.open") : UIImage(systemName: "lock"), identifier: .none, discoverabilityTitle: "", attributes: [], state: .off) {_ in
                        LockNote().authenticate(title: self.isNoteLocked! ? "Lock this note" : "Unlock this note", onCompleted: {result, error in
                            
                            if error == nil {
                                
                                self.isNoteLocked = !self.isNoteLocked!
                                self.moreButton?.menu = self.moreButtonTapped()
                            } else {
                                ToastNotification().showToast(backgroundColor: .systemBlue, image: UIImage(systemName: "pin")!, titleText: "DDDD", subtitleText: nil, progress: 4.0)
                            }
                        })
                    },
                    
                    UIAction(title: "Change Date", subtitle: self.currentNote?.date?.formatted(), image: UIImage(systemName: "calender"), identifier: .none, discoverabilityTitle: "String? = nil",  attributes: [], state: .off) { _ in
                        
                        let vc = ChangeDateViewController()
                        let navController = UINavigationController(rootViewController: vc)
                        vc.note = self.currentNote
                        
                        switch currentDevice {
                        case .iphone:
                            self.present(navController, animated: true, completion: nil)
                        case .ipad, .mac:
                            navController.modalPresentationStyle = UIModalPresentationStyle.popover
                            navController.preferredContentSize = CGSize(width: 375, height: 425)
                            navController.popoverPresentationController?.sourceView = self.view
                            self.present(navController, animated: true, completion: nil)
                        case .none:
                            return
                        }
                    },
                    
                ]
                
                return UIMenu(children: children)
            }
        } else {
            print("debugDescr")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeStrokeType(notification:)), name: Notification.Name("changedStrokeType"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeSize(notification:)), name: Notification.Name("changedWidth"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeColor(notification:)), name: Notification.Name("changedColor"), object: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(autoSaveNote), userInfo: nil, repeats: true)
    }
    
    @objc func showPenMenu(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "penMenu") as! ToolOptionsViewController
        let navController = UINavigationController(rootViewController: vc)
    
        present(navController, animated: true, completion: nil)
    }
    
    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func autoSaveNote() {
        saveNote(currentNote: currentNote, title: noteTitleField.text!, textboxes: textBoxes, date: noteDateField.date, tags: noteTagsField.tags.map({$0.text}), isLocked: isNoteLocked ?? false)
        
        NotificationCenter.default.post(name: Notification.Name("UpdateNotesTable"), object: nil)
    }
    
    
    @objc func editTagsButtonTapped(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editTagsVC") as! EditTagsTableViewController
        let navController = UINavigationController(rootViewController: vc)
        vc.note = self.currentNote
        
        switch currentDevice {
        case .iphone:
            present(navController, animated: true, completion: nil)
        case .ipad, .mac:
            navController.modalPresentationStyle = UIModalPresentationStyle.popover
            navController.preferredContentSize = CGSize(width: 375, height: 300)
            navController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            present(navController, animated: true, completion: nil)
        case .none:
            return
        }
    }
    
    @objc func printLetter() {
        print("SLSLLS")
    }
    
    func shareButtonTapped(menuOption: UIMenu.Options) -> UIMenu {
        var locations = [UIAction]()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shareNoteVC") as! NoteShareSettingsViewController
        let navigationController = UINavigationController(rootViewController: vc)
        
        for location in SharingLocation.allCases {
            locations.append( UIAction(title: "\(location.viewTitle)", image: location.icon, identifier: nil, attributes: []) { _ in

                switch currentDevice {
                case .iphone:
                    if let picker = navigationController.presentationController as? UISheetPresentationController {
                       picker.detents = [.medium()]
                       picker.prefersGrabberVisible = true
                       picker.preferredCornerRadius = 7.0
                    }
                case .ipad, .mac:
                    navigationController.modalPresentationStyle = UIModalPresentationStyle.popover
                  navigationController.preferredContentSize = CGSize(width: 375, height: 300)
                    navigationController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
                    
                
                case .none:
                    return
                }
                
                vc.currentNoteView = self.drawingVIew.createPDF() as Data
                vc.currentNote = self.currentNote
                vc.sharingLocation = location
                
                self.present(navigationController, animated: true, completion: nil)
             })
          }
        
        return UIMenu(title: "Share Note", subtitle: nil, image: nil, identifier: nil, options: menuOption, children: locations)
        
    }
    
    @objc func penTool(_ sender: UIBarButtonItem) {
        if drawingVIew.tool == .pen {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "penMenu") as! ToolOptionsViewController
            let navigationController = UINavigationController(rootViewController: vc)
            if currentDevice == .iphone {
                if let picker = navigationController.presentationController as? UISheetPresentationController {
                picker.detents = [.medium()]
                picker.prefersGrabberVisible = true
                picker.preferredCornerRadius = 5.0
                }
            }
            self.present(navigationController, animated: true)
        } else {
            drawingVIew.tool = .pen
        }
        
    }
    
    @objc func highlighterTool(sender: UIButton) {
        if drawingVIew.tool == .highlighter {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "penMenu") as! ToolOptionsViewController
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true)
        } else {
            drawingVIew.tool = .text
        }
        
    }
    
    @objc func changeStrokeType(notification: Notification) {
        if drawingVIew.tool == .pen {
            drawingVIew.currentPen?.strokeType = StrokeTypes(rawValue: UserDefaults.standard.integer(forKey: "changedStrokeType")) ?? .normal
            
        } else {
            drawingVIew.currentHighlighter?.strokeType = StrokeTypes(rawValue: UserDefaults.standard.integer(forKey: "changedStrokeType")) ?? .normal
        }
    }
    
    @objc func changeColor(notification: Notification) {
        if drawingVIew.tool == .pen {
            drawingVIew.currentPen?.color = UIColor(hex: UserDefaults.standard.string(forKey: "changedColor")!)!
        } else {
            drawingVIew.currentHighlighter?.color = UIColor(hex: UserDefaults.standard.string(forKey: "changedColor")!)!
        }
    }
    
    @objc func changeSize(notification: Notification) {
        if drawingVIew.tool == .pen {
            drawingVIew.currentPen?.width = UserDefaults.standard.double(forKey: "changedWidth") 
        } else {
            drawingVIew.currentHighlighter?.width = UserDefaults.standard.double(forKey: "changedWidth")
        }
    }
    
    @objc func moreButtonTapped() -> UIMenu {

        let lockTitle = self.isNoteLocked ?? false ? "Unlock note" : "Lock note"
        let lockImage = self.isNoteLocked! ? "lock.open" : "lock"
        
        var lockNote = UIAction(title: lockTitle, subtitle: "", image: UIImage(systemName: lockImage), identifier: .none, discoverabilityTitle: "", attributes: [], state: .off, handler: {_ in
            LockNote().authenticate(title: self.isNoteLocked! ? "Lock this note" : "Unlock this note", onCompleted: {result, error in
                
                if error == nil {
                    
                    self.isNoteLocked = !self.isNoteLocked!
                    self.moreButton?.menu = self.moreButtonTapped()
                } else {
                    ToastNotification().showToast(backgroundColor: .systemBlue, image: UIImage(systemName: "pin")!, titleText: "DDDD", subtitleText: nil, progress: 4.0)
                }
            })
        })
        
        return UIMenu(title: "", children: [shareButtonTapped(menuOption: []), lockNote])
    }
}

extension NoteViewController: UINavigationItemRenameDelegate {
    
    func navigationItem(_: UINavigationItem, didEndRenamingWith title: String) {
        navigationItem.title = title
    }
}

extension NoteViewController: PHPickerViewControllerDelegate {
    
    @objc func presentPhotoPicker(_ sender: UIBarButtonItem) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    //Image Picker
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                   
                   itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                       DispatchQueue.main.async {
                           guard let self = self, let image = image as? UIImage else { return }
                          
                           self.drawingVIew.insertImage(frame: CGRect(x: self.drawingVIew.bounds.midX, y: self.drawingVIew.bounds.midY, width: image.size.width ?? 200, height: image.size.height ?? 200), image: image)
                       }
                   }
               }
    }
    
    func addString(string: String) {
        listOfTags.append(string)
    }
}
