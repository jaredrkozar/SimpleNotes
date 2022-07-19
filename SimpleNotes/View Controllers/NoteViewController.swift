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
    
    let drawingView = DrawingView(frame: CGRect.zero)
    
    var dadteHandler: DateHandler?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    public var tool: Tools {
        get {
            return drawingView.tool ?? .pen
        }
        set {
            drawingView.currentView?.isNotCurrentView()
            if newValue == .scroll {
                self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1
                drawingView.isUserInteractionEnabled = true
            } else {
                self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
            }
            drawingView.tool = newValue
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var isNoteLocked: Bool?
    var timer: Timer?
    
    var currentNote: Note?
    
    var textBoxes = [CustomTextBox]()
    
    var moreButton: UIBarButtonItem?
    
    var listOfTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(drawingView)
        scrollView.delegate = self
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            drawingView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            drawingView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            drawingView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            drawingView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            drawingView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            drawingView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.5
        
        ToastNotification().showToast(backgroundColor: .systemBlue, image: UIImage(systemName: "pin")!, titleText: "DDDD", subtitleText: nil, progress: 4.0)
        
        // Do any additional setup after loading the view.
        
        tool = .pen
        drawingView.backgroundColor = .systemBackground
        
        drawingView.currentPen = PenTool(width: 20.0, color: .systemPink, opacity: 1.0, blendMode: .normal, strokeType: .normal)
        
        drawingView.currentHighlighter = PenTool(width: 20.0, color: .systemYellow, opacity: 0.6, blendMode: .normal, strokeType: .normal)
        
        if #available(iOS 16.0, *) {
            self.navigationItem.style = .editor
            self.navigationItem.title = currentNote?.title
                        
            for menuTool in Tools.allCases {
                navigationItem.centerItemGroups.append(UIBarButtonItem(title: menuTool.name, image: menuTool.icon, primaryAction: UIAction { _ in
                    
                    
                    if (menuTool == self.tool) && (menuTool.optionsView != nil) {
                        
                        switch currentDevice {
                        case .iphone:
                            
                            let navigationController = UINavigationController(rootViewController: menuTool.optionsView!)
                            if let picker = navigationController.presentationController as? UISheetPresentationController {
                                picker.detents = [.medium()]
                                picker.prefersGrabberVisible = true
                                picker.preferredCornerRadius = 5.0
                            }
                            self.present(navigationController, animated: true, completion: nil)
                            
                        case .ipad, .mac:
                            let navigationController = UINavigationController(rootViewController: menuTool.optionsView!)
                            navigationController.modalPresentationStyle = UIModalPresentationStyle.popover
                            self.navigationController?.preferredContentSize = CGSize(width: 350, height: 225)
                            navigationController.popoverPresentationController?.barButtonItem = self.navigationItem.centerItemGroups[menuTool.rawValue].barButtonItems.first
                            self.present(navigationController, animated: true, completion: nil)
                        case .none:
                            print("NONE")
                        }
                        
                    } else {
                        self.tool = menuTool
                    }
                }).creatingMovableGroup(customizationIdentifier: tool.name))
            }
            
            navigationItem.renameDelegate = self
            navigationItem.titleMenuProvider = { suggestedActions in
                
                var children = suggestedActions
                children += [
                    
                    UIAction(title: "Edit Tags", subtitle: "\tags", image: UIImage(systemName: "pin"), identifier: .none, discoverabilityTitle: "String? = nil",  attributes: [], state: .off) { _ in
                        
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
                            navController.preferredContentSize = CGSize(width: 375, height: 500)
                            navController.popoverPresentationController?.sourceView = self.view
                            self.present(navController, animated: true, completion: nil)
                        case .none:
                            return
                        }
                    },
                    
                    self.shareButtonTapped()
                ]
    
                return UIMenu(children: children)
            }
        } else {
            print("debugDescr")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeStrokeType(notification:)), name: Notification.Name("changedStrokeType"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeSize(notification:)), name: Notification.Name("changedWidth"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeColor(notification:)), name: Notification.Name("changedColor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(tintColorChanged(notification:)), name: Notification.Name("tintColorChanged"), object: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(autoSaveNote), userInfo: nil, repeats: true)
    }
    
    @available(iOS 16.0, *)
    func shareButtonTapped() -> UIMenu {
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
                     navigationController.popoverPresentationController?.sourceItem = self.navigationItem.titleView
                     
                 
                 case .none:
                     return
                 }
                 
                 vc.currentNoteView = self.drawingView.createPDF() as Data
                 vc.currentNote = self.currentNote
                 vc.sharingLocation = location
                 
                 self.present(navigationController, animated: true, completion: nil)
              })
           }
         
        return UIMenu(title: "Share Note", subtitle: nil, image: nil, identifier: nil, options: [], children: locations)
         
     }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return drawingView
    }
    
    @objc func showPenMenu(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "penMenu") as! ToolOptionsViewController
        let navController = UINavigationController(rootViewController: vc)
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc func handTool(_ sender: UIBarButtonItem) {
        tool = .scroll
    }
    
    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func autoSaveNote() {
        saveNote(currentNote: currentNote, title: navigationItem.title ?? "New Note", textboxes: textBoxes, date: dadteHandler?.dateHandler() ?? Date.now, tags: ["noteTagsField.tags.map({$0.text})"], isLocked: isNoteLocked ?? false)
        
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
    
    @objc func tintColorChanged(notification: Notification) {
        navigationController?.navigationBar.tintColor = UIColor(hex: UserDefaults.standard.string(forKey: "tintColor")!)
  
        self.view.tintColor = UIColor(hex: (UserDefaults.standard.string(forKey: "tintColor") ?? UIColor.systemBlue.toHex)!)
    }
    
    
    @objc func changeStrokeType(notification: Notification) {
        if tool == .pen {
            drawingView.currentPen?.strokeType = StrokeTypes(rawValue: UserDefaults.standard.integer(forKey: "changedStrokeType")) ?? .normal
            
        } else {
            drawingView.currentHighlighter?.strokeType = StrokeTypes(rawValue: UserDefaults.standard.integer(forKey: "changedStrokeType")) ?? .normal
        }
    }
    
    @objc func changeColor(notification: Notification) {
        if tool == .pen {
            drawingView.currentPen?.color = UIColor(hex: UserDefaults.standard.string(forKey: "changedColor")!)!
        } else {
            drawingView.currentHighlighter?.color = UIColor(hex: UserDefaults.standard.string(forKey: "changedColor")!)!
        }
    }
    
    @objc func changeSize(notification: Notification) {
        if tool == .pen {
            drawingView.currentPen?.width = UserDefaults.standard.double(forKey: "changedWidth")
        } else {
            drawingView.currentHighlighter?.width = UserDefaults.standard.double(forKey: "changedWidth")
        }
    }
}

extension NoteViewController: UINavigationItemRenameDelegate {
    
    func navigationItem(_: UINavigationItem, didEndRenamingWith title: String) {
        navigationItem.title = title
        saveNote(currentNote: currentNote, title: title, textboxes: [], date: Date.now, tags: ["HE::O"], isLocked: currentNote!.isLocked)
        NotificationCenter.default.post(name: Notification.Name("reloadNotesTable"), object: nil)
        
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
                          
                           self.drawingView.insertImage(frame: CGRect(x: self.drawingView.bounds.midX, y: self.drawingView.bounds.midY, width: image.size.width ?? 200, height: image.size.height ?? 200), image: image)
                       }
                   }
               }
    }
    
    func addString(string: String) {
        listOfTags.append(string)
    }
}

extension NoteViewController: UISearchResultsUpdating {
    func fetchQuerySuggestions(for searchController: UISearchController) -> [(String, UIImage?)] {
        let queryText = searchController.searchBar.text
        // Here you would decide how to transform the queryText into search results. This example just returns something fixed.
        return [("Sample Suggestion", UIImage(systemName: "rectangle.and.text.magnifyingglass"))]
    }
    
    func updateSearch(_ searchController: UISearchController, query: String) {
        // This method is used to update the search UI from our query text change
        // You should also update internal state related to when the query changes, as you might for when the user changes the query by typing.
        searchController.searchBar.text = query
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if #available(iOS 16.0, *) {
            let querySuggestions = self.fetchQuerySuggestions(for: searchController)
            searchController.searchSuggestions = querySuggestions.map { name, icon in
                UISearchSuggestionItem(localizedSuggestion: name, localizedDescription: nil, iconImage: icon)
            }
        }
    }

    @available(iOS 16.0, *)
    func updateSearchResults(for searchController: UISearchController, selecting searchSuggestion: UISearchSuggestion) {
        if #available(iOS 16.0, *) {
            if let suggestion = searchSuggestion.localizedSuggestion {
                updateSearch(searchController, query: suggestion)
            }
        }
    }
}
