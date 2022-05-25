//
//  NewNoteViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/19/21.
//

import UIKit
import WSTagsField

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
        
        noteDateField.date = currentNote?.date ?? Date.now
        
        let editTags = UIBarButtonItem(image: UIImage(systemName: "tag"), style: .plain, target: self, action: #selector(editTagsButtonTapped))
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        let shareButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "square.and.arrow.up"), primaryAction: nil, menu: shareButtonTapped(menuOption: .displayInline))
        
        let flexibleSPace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let undoButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "arrow.uturn.backward"), primaryAction: nil, menu: nil)
        
        let redoButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "arrow.uturn.forward"), primaryAction: nil, menu: nil)
                                            
        moreButton = UIBarButtonItem(title: "More", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: moreButtonTapped())
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
        
        var config = UIImage.SymbolConfiguration(paletteColors: [.systemBlue, .systemYellow])

        var newconfig = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 42.0)))

        let penButton = UIButton()
        penButton.setImage(UIImage(named: "penIcon")?.applyingSymbolConfiguration(newconfig), for: .normal)
        penButton.addTarget(self, action: #selector(penTool(sender:)), for: .touchUpInside)
        penButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
       
        let highlighterButton = UIButton()
        highlighterButton.setImage(UIImage(systemName: "folder", withConfiguration: largeConfig), for: .normal)
        highlighterButton.addTarget(self, action: #selector(highlighterTool(sender:)), for: .touchUpInside)
        highlighterButton.frame = CGRect(x: 60, y: 0, width: 44, height: 44)
        
        let toolsView = UIView()
        toolsView.addSubview(penButton)
        toolsView.addSubview(highlighterButton)
        toolsView.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        
        self.navigationItem.titleView = toolsView
        
        switch currentDevice {
        case .iphone:
            self.navigationItem.titleView = toolsView
            self.navigationItem.rightBarButtonItem = moreButton
        case .ipad, .mac:
            self.navigationItem.titleView = toolsView
            self.navigationItem.leftBarButtonItem = shareButton
        case .none:
            return
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
        vc.newNoteVC = noteTagsField
        
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
    
    @objc func penTool(sender: UIButton) {
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
}
