//
//  NewNoteViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/19/21.
//

import UIKit
import WSTagsField
import PhotosUI

class NoteViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet var drawingVIew: DrawingView!
    
    var isNoteLocked: Bool?
    var timer: Timer?
    
    var currentNote: Note?
    
    var textBoxes = [CustomTextBox]()
    
    var moreButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ToastNotification().showToast(backgroundColor: .systemBlue, image: UIImage(systemName: "pin")!, titleText: "DDDD", subtitleText: "This is a sample toast message", progress: nil)
        
        // Do any additional setup after loading the view.
        drawingVIew.setup()
        drawingVIew.tool = .pen
        drawingVIew.currentPen = PenTool(width: 20.0, color: .systemPink, opacity: 1.0, blendMode: .normal, strokeType: .dotted)
        
        drawingVIew.currentHighlighter = PenTool(width: 20.0, color: .systemYellow, opacity: 0.6, blendMode: .normal, strokeType: .dashed)
        
        let shareButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "square.and.arrow.up"), primaryAction: nil, menu: shareButtonTapped(menuOption: .displayInline))
        
        if #available(iOS 16.0, *) {
            navigationItem.style = .editor
            navigationItem.title = currentNote?.title ?? "New Note"
            
                if currentDevice == .ipad {
                    navigationItem.backBarButtonItem?.isHidden = true
                }

            navigationItem.centerItemGroups = [
                UIBarButtonItem(image: UIImage(systemName: "character.textbox"), style: .plain, target: self, action: #selector(textToolSelected)).creatingOptionalGroup(customizationIdentifier: "textTool"),
                
                UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(penToolSelected(_:))).creatingOptionalGroup(customizationIdentifier: "penTool"),
                
                UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(selectPhoto(_:))).creatingOptionalGroup(customizationIdentifier: "photoTool")
                  
            ]
    
            navigationItem.renameDelegate = self
            navigationItem.titleMenuProvider = { suggestedActions in
                var children = suggestedActions
                children += [

                    UIAction(title: "Change Date", subtitle: self.currentNote?.date?.formatted(), image: UIImage(systemName: "calendar"), identifier: .none, discoverabilityTitle: "Change Date", attributes: [], state: .off) {
                        _ in
                        
                    },
                    
                    UIAction(title: "Edit Tags", image: UIImage(systemName: "tag")) { _ in
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editTagsVC") as! EditTagsTableViewController
                        let navController = UINavigationController(rootViewController: vc)
                        vc.newNoteVC = self.noteTagsField
                        
                        switch currentDevice {
                        case .iphone:
                            self.present(navController, animated: true, completion: nil)
                        case .ipad, .mac:
                            navController.modalPresentationStyle = UIModalPresentationStyle.popover
                            navController.preferredContentSize = CGSize(width: 375, height: 300)
                            navController.sheetPresentationController?.sourceView = self.view
                            navController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
                            self.present(navController, animated: true, completion: nil)
                        case .none:
                            return
                        }
                    }
                    
                    
                ]
                return UIMenu(children: children)
            }
       } else {
           print("DDD")
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
    
    @objc func textToolSelected() {
        drawingVIew.tool = .text
    }
    
    func changeToolsMenu() -> UIMenu {
        var toolsMenu = [UIAction]()
        for tool in Tools.allCases {
        
            toolsMenu.append( UIAction(title: "\(tool.name)", image: nil, identifier: nil, attributes: []) { _ in

                self.drawingVIew.tool = tool
             })
          }
        
        return UIMenu(title: "Share Note", subtitle: nil, image: nil, identifier: nil, options: .singleSelection, children: toolsMenu)
        
    }
    
    @objc func penToolSelected(_ sender: UIBarButtonItem) {
        if currentDevice == .iphone {
            presentSettingsStoryboard(identifier: "penMenu", source: sender)
        } else {
            if drawingVIew.tool == .pen {
                presentSettingsStoryboard(identifier: "penMenu", source: sender)
            } else {
                drawingVIew.tool = .pen
            }
        }
    }
    
    @objc func highlighterTool(sender: UIBarButtonItem) {
        if currentDevice == .iphone {
            presentSettingsStoryboard(identifier: "penMenu", source: sender)
        } else {
            if drawingVIew.tool == .highlighter {
                presentSettingsStoryboard(identifier: "penMenu", source: sender)
            } else {
                drawingVIew.tool = .highlighter
            }
        }
    }
    
    @objc func eraserTool(sender: UIBarButtonItem) {
        if currentDevice == .iphone {
            presentSettingsStoryboard(identifier: "penMenu", source: sender)
        } else {
            if drawingVIew.tool == .eraser {
                presentSettingsStoryboard(identifier: "penMenu", source: sender)
            } else {
                drawingVIew.tool = .eraser
            }
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
    
        var showTags = UIAction(title: "Tags", subtitle: "", image: UIImage(systemName: "tag"), identifier: .none, discoverabilityTitle: "", attributes: [], state: .off, handler: {_ in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editTagsVC") as! EditTagsTableViewController
            let navController = UINavigationController(rootViewController: vc)
            vc.newNoteVC = self.noteTagsField
            
            self.present(navController, animated: true, completion: nil)
        })
        
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
        
        return UIMenu(title: "", children: [shareButtonTapped(menuOption: []), lockNote, showTags])
    }
    
    func presentSettingsStoryboard(identifier: String, source: UIBarButtonItem) {
        let vc = ToolOptionsViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        if currentDevice == .iphone {
            if let picker = navigationController.presentationController as? UISheetPresentationController {
            picker.detents = [.medium()]
            picker.prefersGrabberVisible = true
            picker.preferredCornerRadius = 5.0
            }
        } else {
            navigationController.modalPresentationStyle = UIModalPresentationStyle.popover

            if let popoverPresentationController = navigationController.popoverPresentationController {
                     popoverPresentationController.permittedArrowDirections = .init([.up,.down])
                
                if #available(iOS 16.0, *) {
                    popoverPresentationController.sourceItem = source
                } else {
                    popoverPresentationController.barButtonItem = source
                }
                
                navigationController.preferredContentSize = CGSize(width: 535, height: 300)
                  
                     popoverPresentationController.delegate = self
                 }
        }
        self.present(navigationController, animated: true)
    }
}

extension NoteViewController: UINavigationItemRenameDelegate {
    func navigationItem(_: UINavigationItem, didEndRenamingWith title: String) {
        NotificationCenter.default.post(name: Notification.Name("UpdateNotesTable"), object: nil)
    }
}

extension NoteViewController: PHPickerViewControllerDelegate {
    @objc func selectPhoto(_ sender: UIBarButtonItem) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    //Image Picker
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        //set the photo symbol to previousImage and set the image the user selected to imageView.image, which displays it in the image view on the left side of the screen
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage else { return }
                    self.drawingVIew.insertImage(frame: CGRect(x: self.drawingVIew.bounds.midX, y: self.drawingVIew.bounds.midY, width: image.size.width, height: image.size.height), image: image)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
