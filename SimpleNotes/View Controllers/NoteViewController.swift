//
//  NewNoteViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/19/21.
//

import UIKit
import WSTagsField
import PhotosUI

class NoteViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let drawingView = DrawingView(frame: CGRect.zero)
    
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
    
    var timer: Timer?
    
    var currentNote: Note?
    
    var noteIndex: Int!
    
    var noteTitle: String?
    var noteDate: Date?
    var isNoteLocked: Bool?
    
    var moreButton: UIBarButtonItem?
    
    var listOfTags = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name( "tintColorChanged"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchController.searchResultsUpdater = self
        
        if noteIndex == nil {
            
                view.backgroundColor = .systemBackground
            self.navigationItem.title = nil
            let noNoteLabel = UILabel()
            noNoteLabel.textAlignment = .center
            noNoteLabel.text = "Select a note on the left, or tap the New Note button on the upper right"
            noNoteLabel.textColor = .systemGray2
            noNoteLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
            noNoteLabel.numberOfLines = 0
            noNoteLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(noNoteLabel)
            
            NSLayoutConstraint.activate([
                noNoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                noNoteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                noNoteLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.70),
                
                noNoteLabel.heightAnchor.constraint(equalToConstant: 600)
            ])
        }
        else {
            
            self.navigationItem.title = fetchNoteTitle(index: noteIndex!)
            noteDate = fetchDate(index: noteIndex)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            drawingView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(scrollView)
            scrollView.addSubview(drawingView)
            scrollView.delegate = self
            
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                drawingView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                drawingView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                drawingView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                drawingView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                drawingView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                drawingView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        }
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.5
        
        ToastNotification().showToast(backgroundColor: .systemBlue, image: UIImage(systemName: "pin")!, titleText: "DDDD", subtitleText: nil, progress: 4.0)
        
        // Do any additional setup after loading the view.
        
        tool = .pen
        drawingView.backgroundColor = .systemBackground
        
        drawingView.currentPen = PenTool(width: 20.0, color: .systemPink, opacity: 1.0, blendMode: .normal, strokeType: .normal)
        
        drawingView.currentHighlighter = PenTool(width: 20.0, color: .systemYellow, opacity: 0.6, blendMode: .normal, strokeType: .normal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), menu: addMediaMenu())
        
        self.navigationItem.style = .editor
                    
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
                        navigationController.preferredContentSize = CGSize(width: 500, height: 250)
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
                    
                    let vc = EditTagsTableViewController()
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
                
                UIAction(title: fetchNoteLockedStatus(index: self.noteIndex!) == true ? "Unlock Note" : "Lock Note", subtitle: "", image: fetchNoteLockedStatus(index: self.noteIndex!) == true ? UIImage(systemName: "lock.open") : UIImage(systemName: "lock"), identifier: .none, discoverabilityTitle: "", attributes: [], state: .off) {_ in
                    LockNote().authenticate(title: self.isNoteLocked! ? "Lock this note" : "Unlock this note", onCompleted: {result, error in
                        
                        if error == nil {
                            
                            self.isNoteLocked = !self.isNoteLocked!
                            saveNoteLock(isLocked: self.isNoteLocked!, index: self.noteIndex!)
                        } else {
                            ToastNotification().showToast(backgroundColor: .systemBlue, image: UIImage(systemName: "pin")!, titleText: "DDDD", subtitleText: nil, progress: 4.0)
                        }
                    })
                },
                
                UIAction(title: "Change Date", subtitle: self.noteDate?.formatted(), image: UIImage(systemName: "calender"), identifier: .none, discoverabilityTitle: "String? = nil",  attributes: [], state: .off) { _ in
                    
                    let vc = ChangeDateViewController()
                    let navController = UINavigationController(rootViewController: vc)
                    vc.source = self
                    vc.noteDate = self.noteDate
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

        NotificationCenter.default.addObserver(self, selector: #selector(changeStrokeType(notification:)), name: Notification.Name("changedStrokeType"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeSize(notification:)), name: Notification.Name("changedWidth"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeColor(notification:)), name: Notification.Name("changedColor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(tintColorChanged(notification:)), name: Notification.Name("tintColorChanged"), object: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(autoSaveNote), userInfo: nil, repeats: true)
    }
    
    @available(iOS 16.0, *)
    func shareButtonTapped() -> UIMenu {
         var locations = [UIAction]()
         let vc = NoteShareSettingsViewController()
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
    
    @objc func autoSaveNote() {
        if currentNote != nil {

            NotificationCenter.default.post(name: Notification.Name("UpdateNotesTable"), object: nil)
        }
    }
    
    
    @objc func editTagsButtonTapped(_ sender: Any) {
        
        let vc = EditTagsTableViewController()
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
    
    func dateChanged(date: Date) {
        noteDate = date
        saveDate(date: date, index: noteIndex)
        NotificationCenter.default.post(name: Notification.Name("reloadNotesTable"), object: nil)
    }
    
    @objc func tintColorChanged(notification: Notification) {
        navigationController?.navigationBar.tintColor = UIColor(hex: (UserDefaults.standard.string(forKey: "tintColor") ?? UIColor.systemBlue.toHex)!)
  
        self.view.tintColor = UIColor(hex: (UserDefaults.standard.string(forKey: "tintColor") ?? UIColor.systemBlue.toHex)!)
    }
    
    @objc func changeColor(notification: Notification) {
        if tool == .pen {
            drawingView.currentPen?.color = UIColor(hex: UserDefaults.standard.string(forKey: "color")!)!
        } else {
            drawingView.currentHighlighter?.color = UIColor(hex: UserDefaults.standard.string(forKey: "color")!)!
        }
    }
    
    @objc func changeSize(notification: Notification) {
        if tool == .pen {
            drawingView.currentPen?.width = UserDefaults.standard.double(forKey: "width")
        } else {
            drawingView.currentHighlighter?.width = UserDefaults.standard.double(forKey: "width")
        }
    }
    
    @objc func changeStrokeType(notification: Notification) {
        if tool == .pen {
            drawingView.currentPen?.strokeType = StrokeTypes(rawValue: UserDefaults.standard.integer(forKey: "strokeType")) ?? .normal
            
        } else {
            drawingView.currentHighlighter?.strokeType = StrokeTypes(rawValue: UserDefaults.standard.integer(forKey: "strokeType")) ?? .normal
        }
    }
}

extension NoteViewController: UINavigationItemRenameDelegate {
    
    func navigationItem(_: UINavigationItem, didEndRenamingWith title: String) {
        navigationItem.title = title
        saveTitle(title: title, index: noteIndex!)
        NotificationCenter.default.post(name: Notification.Name("reloadNotesTable"), object: nil)
        
    }
    
    @objc func addMediaMenu() -> UIMenu {
        let presentPhotosPicker = UIAction(title: "Photos Library", image: UIImage(systemName: "photo"), identifier: nil, discoverabilityTitle: nil, attributes: [], state: .on) { _ in
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        let presentCameraPicker = UIAction(title: "Camera", image: UIImage(systemName: "camera"), identifier: nil, discoverabilityTitle: nil, attributes: [], state: .on) {_ in
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        }
        
        return UIMenu(title: "Add Media", image: nil, identifier: nil, options: .singleSelection, children: [presentPhotosPicker, presentCameraPicker])
    }
}

extension NoteViewController: PHPickerViewControllerDelegate {
    //Image Picker
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                   
                   itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                       DispatchQueue.main.async {
                           guard let self = self, let image = image as? UIImage else { return }
                          
                           let dimension: CGFloat = 400
                           
                           let maxDimension =  CGFloat(max(image.size.width, image.size.height))
                           let scale = dimension / maxDimension
                           var rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
                           let transform = CGAffineTransform(scaleX: scale, y: scale)
                           rect = rect.applying(transform)
                           print(CGFloat(rect.width) / 2)
                           self.drawingView.insertImage(frame: CGRect(x: (rect.width + (-1 * CGFloat(rect.width) / 2)), y: (rect.height + (-1 * CGFloat(rect.height) / 2)), width: rect.width, height: rect.height), image: image)
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
