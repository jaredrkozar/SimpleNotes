//
//  NewNoteViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/19/21.
//

import UIKit
import WSTagsField
import PhotosUI
import PDFKit

class NoteViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let drawingView = DrawingView(frame: .zero)
    let pdfHolderView = UIView(frame: .zero)
    var baseView = UIView(frame: .zero)
    
    private let scrollView = UIScrollView(frame: .zero)
    
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

    var pdfDocument: PDFDocument?
    
    private var offsets = [Border]()
    
    private var visiblePages = [CustomPDFPage]()
    
    private var pageDisplayType: PageDisplayType?
    
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
        } else {
            pageDisplayType = .vertical
    
            offsets.append(contentsOf: getAllPageOffsets(page: (pdfDocument?.page(at: 0))!, numberOfPages: pdfDocument!.pageCount))
            
            for page in 0..<(pdfDocument!.pageCount) {
                drawPage(num: page)
            }
            
            drawingView.backgroundColor = .clear
            self.navigationItem.title = fetchNoteTitle(index: noteIndex!)
            self.navigationItem.largeTitleDisplayMode = .never
            noteDate = fetchDate(index: noteIndex)
        
            baseView.addSubview(pdfHolderView)
            baseView.addSubview(drawingView)
            
            view.addSubview(scrollView)
            scrollView.addSubview(baseView)
            scrollView.delegate = self
            
            var rect = CGRect()
            
            switch pageDisplayType {
                case .horizontal:
                rect = CGRect(x: 0, y: 0, width: offsets.last?.maxX ?? 0, height: offsets.last!.maxY)
                scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: offsets.last!.maxY)
                    break
                case .vertical:
                rect = CGRect(x: 0, y: 0, width: offsets.last!.maxX, height: offsets.last!.maxY)
                scrollView.frame = CGRect(x: 0, y: 0, width: offsets.last!.maxX, height: view.frame.height)
                    break
            default:
                return
                }
            
            drawingView.frame = rect
            pdfHolderView.frame = rect
            baseView.frame = rect
            scrollView.contentSize = CGSize(width: 500, height: 100)
        }
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.5
    
        // Do any additional setup after loading the view.
        
        tool = .pen
        
        drawingView.currentPen = PenTool(width: 20.0, color: .systemPink, opacity: 1.0, blendMode: .normal, strokeType: .normal)
        
        drawingView.currentHighlighter = PenTool(width: 20.0, color: .systemYellow, opacity: 0.6, blendMode: .normal, strokeType: .normal)
        
        let undoButton = UIBarButtonItem(title: "Undo", image: UIImage(systemName: "arrow.uturn.left.circle"), target: self, action: #selector(undoStroke))
        
        let redoButton = UIBarButtonItem(title: "Redo", image: UIImage(systemName: "arrow.uturn.right.circle"), target: self, action: #selector(redoStroke))
        
        let addMedia = UIBarButtonItem(title: "Add Media", image: UIImage(systemName: "plus"), target: self, action: nil, menu: addMediaMenu())
        
        navigationItem.rightBarButtonItems = [addMedia, redoButton, undoButton]
        
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
                
                UIAction(title: "Edit Tags", subtitle: "\(fetchTagsForNote(index: self.noteIndex).count) tags", image: UIImage(systemName: "tag"), identifier: .none, discoverabilityTitle: "Change the tags in this note",  attributes: [], state: .off) { _ in
                    
                    let vc = EditTagsTableViewController()
                    let navController = UINavigationController(rootViewController: vc)
                    vc.index = self.noteIndex
                    
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
                
                UIAction(title: "Go to Page", subtitle: nil, image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), identifier: .none, discoverabilityTitle: "Go to a specific page in this note",  attributes: [], state: .off) {_ in
                    
                    let ac = UIAlertController(title: "Go to Page", message: "There are \(self.pdfDocument!.pageCount) pages in this note.", preferredStyle: .alert)
                    ac.addTextField()
                    
                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        
                    ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                        let textField = ac?.textFields![0]
                        textField?.keyboardType = .decimalPad
                        let numEntered = Int(textField!.text!)
                        if numEntered! <= self!.pdfDocument!.pageCount {
                            self!.goToPage(pageNum: numEntered!)
                        }

                    })
                    self.present(ac, animated: true)
                    
                },
                UIAction(title: fetchNoteLockedStatus(index: self.noteIndex!) == true ? "Unlock Note" : "Lock Note", subtitle: "", image: fetchNoteLockedStatus(index: self.noteIndex!) == true ? UIImage(systemName: "lock.open") : UIImage(systemName: "lock"), identifier: .none, discoverabilityTitle: "", attributes: [], state: .off) {_ in
                    LockNote().authenticate(title: self.isNoteLocked! ? "Lock this note" : "Unlock this note", onCompleted: {result, error in
                        
                        if error == nil {
                            
                            self.isNoteLocked = !self.isNoteLocked!
                            saveNoteLock(isLocked: self.isNoteLocked!, index: self.noteIndex!)
                        } else {
                            ToastNotification(backgroundColor: .systemBlue, image: UIImage(systemName: "pin")!, titleText: "DDDD", progress: 0.25)
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
    
    func goToPage(pageNum: Int) {
        scrollView.setContentOffset(CGPoint(x: self.offsets[pageNum - 1].minX, y: self.offsets[pageNum - 1].minY), animated: true)
    }
    
    func getAllPageOffsets(page: PDFPage, numberOfPages: Int) -> [Border] {
        
        let pageSize = CGSize(width: (page.bounds(for: .mediaBox).width), height: (page.bounds(for: .artBox).height))
        var offsets = [Border]()
               
        if (pageDisplayType == .vertical){
           offsets.append(Border(minX: 0, minY: 0, maxX: view.frame.width, maxY: pageSize.height))
       } else {
           offsets.append(Border(minX: 0, minY: 0, maxX: pageSize.width, maxY: view.frame.height))
       }
        
       for counter in  1 ..< numberOfPages{
           var upPage = pdfDocument!.page(at: counter)
           var lastPage = offsets.last
           
           let border: Border
           switch pageDisplayType {
           case .horizontal:
               border = Border(minX: lastPage!.maxX, minY: lastPage!.minY, maxX: lastPage!.maxX + upPage!.bounds(for: .artBox).width, maxY: lastPage!.maxY)
               break
           case .vertical:
               border = Border(minX: lastPage!.minX, minY: offsets[counter - 1].maxY, maxX: lastPage!.maxX, maxY: lastPage!.maxY + (upPage!.bounds(for: .artBox).height))
               break
           default:
               border = Border(minX: pdfHolderView.bounds.minX, minY: pdfHolderView.bounds.minY, maxX: pdfHolderView.bounds.maxX, maxY: pdfHolderView.bounds.maxY)
           }
           print("border")
           offsets.append(border)
       }
       return offsets
    }
    
    func drawPage(num: Int) {
        let page = pdfDocument?.page(at: num)
        let pdfpage = CustomPDFPage(frame: CGRect(x: offsets[num].minX, y: offsets[num].minY + 20, width: offsets[num].maxX - offsets[num].minX, height: offsets[num].maxY - offsets[num].minY), page: page)
        pdfHolderView.addSubview(pdfpage)
    }
    
    @objc func undoStroke(_ sender: UIBarButtonItem) {
        drawingView.undoLastStroke()
        
        sender.isEnabled = undoManager!.canUndo
        navigationItem.rightBarButtonItems![1].isEnabled = undoManager!.canRedo
    }
    
    @objc func redoStroke(_ sender: UIBarButtonItem) {
        drawingView.redoLastStroke()
        sender.isEnabled = undoManager!.canRedo
        navigationItem.rightBarButtonItems![2].isEnabled = undoManager!.canUndo
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
                     navigationController.popoverPresentationController?.sourceItem = self.drawingView
                     
                 
                 case .none:
                     return
                 }
                 
                 vc.currentNoteView = self.exportAsPDF()
                 vc.sharingLocation = location
                 vc.currentNoteTitle = self.currentNote?.title
                 self.present(navigationController, animated: true, completion: nil)
              })
           }
         
        return UIMenu(title: "Share Note", subtitle: nil, image: nil, identifier: nil, options: [], children: locations)
         
     }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return baseView
    }
    
    @objc func autoSaveNote() {
        if currentNote != nil {

            NotificationCenter.default.post(name: Notification.Name("UpdateNotesTable"), object: nil)
        }
    }
    
    
    @objc func editTagsButtonTapped(_ sender: Any) {
        
        let vc = EditTagsTableViewController()
        let navController = UINavigationController(rootViewController: vc)
        vc.index = noteIndex
        
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
        navigationController?.navigationBar.tintColor = UIColor(hex: (UserDefaults.standard.string(forKey: "defaultTintColor")!))
  
        self.view.tintColor = UIColor(hex: (UserDefaults.standard.string(forKey: "defaultTintColor")!))
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
    
    func exportAsPDF() -> Data {
        let newPDF = NSMutableData()
        UIGraphicsBeginPDFContextToData(newPDF, CGRect(x: 0,y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height), nil)
        let context = UIGraphicsGetCurrentContext()
        scrollView.setContentOffset(.zero, animated: false)
        for counter in 0 ..< pdfDocument!.pageCount {
            
            scrollView.setContentOffset(CGPoint(x: offsets[counter].minX, y: offsets[counter].minY), animated: false)
                        switch self.pageDisplayType {
                        case .horizontal:
                            scrollView.frame = CGRect(x: scrollView.frame.minX, y: scrollView.frame.minY, width: (offsets[counter].maxX - offsets[counter].minX), height: scrollView.frame.height)
                        case .vertical:
                            scrollView.frame = CGRect(x: scrollView.frame.minX, y: scrollView.frame.minY, width: scrollView.frame.width, height: (offsets[counter].maxY - offsets[counter].minY))
                        case .none:
                            scrollView.frame = .zero
                        }
                        
                        UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height), nil)
            
                        context!.translateBy(x: -offsets[counter].minX, y: -offsets[counter].minY)
            
            scrollView.layer.render(in: context!)
        }
        
        UIGraphicsEndPDFContext()
        return newPDF as Data
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
                           
                           self.drawingView.insertImage(frame: CGRect(x: (rect.width + (-1 * CGFloat(rect.width) / 2)), y: (rect.height + (-1 * CGFloat(rect.height) / 2)), width: rect.width, height: rect.height), image: image)
                           
                           picker.dismiss(animated: true)
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
