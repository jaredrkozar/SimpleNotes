//
//  ViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/8/21.
//

import UIKit
import WSTagsField
import PDFKit
import MobileCoreServices
import UniformTypeIdentifiers
import VisionKit
import Vision

class ViewController: UITableViewController, UINavigationControllerDelegate {
    
    var currentTag: String?
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name( "tintColorChanged"), object: nil)
        fetchNotes(tag: currentTag, sortOption: .titleAscending)
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchNotes(tag: currentTag, sortOption: .titleAscending)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "NoteTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NoteTableViewCell")
        
        tableView.rowHeight = 180
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addNote = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addDefaultNote))
        
        let importMenu = UIBarButtonItem(title: nil, image: UIImage(systemName: "square.and.arrow.down"), primaryAction: nil, menu: importOptionsMenu())
        
        let viewOptions = UIBarButtonItem(title: nil, image: UIImage(systemName: "arrow.up.arrow.down"), primaryAction: nil, menu: viewOptionsMenu())
        
        self.navigationItem.rightBarButtonItems = [addNote, importMenu, viewOptions]
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNotesTable(notification:)), name: Notification.Name("reloadNotesTable"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(tintColorChanged(notification:)), name: Notification.Name("tintColorChanged"), object: nil)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell else {
            fatalError("Unable to dequeue the image cell.")
        }
        
        let singlenote = notes[indexPath.row]

        if singlenote.isLocked == true {
            cell.noteTitle.text = "Note Locked"
        } else {
            cell.noteTitle.text = singlenote.title
        }
        
        cell.noteThumbanil.image = UIImage(data: singlenote.thumbanil!)
        cell.noteDate.text = singlenote.date!.formatted()
        
        cell.tagView?.tags = fetchTagsForNote(index: indexPath.row).sorted()
        cell.tagView?.addTags()
    
        cell.accessibilityLabel = "\(singlenote.title) Created on  \(singlenote.date)"
        
        cell.layoutIfNeeded()
        return cell
    }
    
    @objc func tintColorChanged(notification: Notification) {
 
        navigationController?.navigationBar.tintColor = UIColor(hex: (UserDefaults.standard.string(forKey: "defaultTintColor")!))
  
        self.view.tintColor = UIColor(hex: (UserDefaults.standard.string(forKey: "defaultTintColor")!))
    }
    
    @objc func addDefaultNote(sender: UIBarButtonItem) {
        let templateAsData = PDFDocument()
        templateAsData.insert(PDFPage(image: UIImage(named: "dottedGrid")!)!, at: 0)
        templateAsData.insert(PDFPage(image: UIImage(named: "dottedGrid")!)!, at: 1)
        addNewNote(thumbnail: templateAsData.page(at: 0)!.createThumbnail(), pdf: templateAsData.dataRepresentation()!)
    }
    
    func addNewNote(thumbnail: Data, pdf: Data) {
        createNewNote(thumbnail: thumbnail, pdf: pdf)
        fetchNotes(tag: nil, sortOption: .titleAscending)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        showNote(noteIndex: notes.count - 1)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if fetchNoteLockedStatus(index: indexPath.row) == true {
           
            LockNote().authenticate(title: "View this note", onCompleted: {result, error in
                if error == nil {
                    self.showNote(noteIndex: indexPath.row)
                } else {
                    ToastNotification(backgroundColor: .systemBlue, image: UIImage(systemName: "pin")!, titleText: "DDDD", subtitleText: "DLDLDLDLD")
                }
            })
            
        } else {
            showNote(noteIndex: indexPath.row)
        }
        
       
    }
    
    func showNote(noteIndex: Int?) {
        let vc = NoteViewController()
        vc.noteIndex = noteIndex
        vc.isNoteLocked = fetchNoteLockedStatus(index: noteIndex!)
        
        vc.pdfDocument = PDFDocument(data: notes[noteIndex!].data!)
        if currentDevice == .iphone || self.splitViewController?.traitCollection.horizontalSizeClass == .compact {
            show(vc, sender: true)
        } else if currentDevice == .ipad {
            self.splitViewController?.setViewController(vc, for: .secondary)
        
            self.showDetailViewController(vc, sender: true)

        } else {
            return
        }
    }
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let newWindowAction = UIWindowScene.ActivationAction({ _ in
                
                // Create the user activity that represents the new scene content.
                let userActivity = NSUserActivity(activityType: "com.jkozar.openNote")

                // Return the activation configuration.
                return UIWindowScene.ActivationConfiguration(userActivity: userActivity)

            })
            
            let editAction = UIAction(
              title: "Edit Tags", image: UIImage(systemName: "tag")) { [self] _ in
                //gets the current dimension and splits it up into 2 parts, and saves them so they can be shown in the text fields in editPresetViewController. The editPresetViewController is then shown via a popover
                  let vc = EditTagsTableViewController()
                  let navController = UINavigationController(rootViewController: vc)
                  vc.index = indexPath.row 
                  self.navigationController?.present(navController, animated: true, completion: nil)
                
            }
            
            let deleteAction = UIAction(
                //deletes the current cell
              title: "Delete",
              image: UIImage(systemName: "trash"),
                attributes: .destructive) { [self] _ in
                    
                    if fetchNoteLockedStatus(index: indexPath.row) == true {
                        LockNote().authenticate(title: "Delete this note", onCompleted: {result, error in
                            if error == nil {
                      
                                deleteNote(index: indexPath.row)
                                
                               notes.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                            } else {
                                ToastNotification(backgroundColor: .systemBlue, image: UIImage(systemName: "pin")!, titleText: "DDDD", subtitleText: "DLDLDLDLD")
                            }
                        })
                        
                    } else {
                        deleteNote(index: indexPath.row)
                        
                        notes.remove(at: indexPath.row)
                        
                        self.tableView.reloadData()
                    }
            }
            
            return UIMenu(title: "", children: [newWindowAction, editAction, deleteAction])
        }
    }
    
    func importOptionsMenu() -> UIMenu {
        var importMenu = [UIAction]()
        
        for sort in SharingLocation.allCases {
            if sort.canImport == true {
                importMenu.append(UIAction(title: "\(sort.viewTitle)", image: nil, identifier: .none, discoverabilityTitle: "Sort Options", attributes: [], state: .on, handler: {_ in
                    
                    switch sort {
                    case .files:
                        self.presentFilesPicker()
                    case .scanDocument:
                        self.presentDocumentScanner()
                    case .dropbox:
                        print ("dkdkdd")
                    case .googledrive:
                        self.presentFolderView(service: .googledrive)
                    default:
                        print("Not supported")
                    }
                }))
            }
        }

        return UIMenu(title: "View Options", image: nil, identifier: nil, options: .singleSelection, children: importMenu)
        
    }
    
    func viewOptionsMenu() -> UIMenu {
        var sortoptions = [UIAction]()
        var viewoptions = [UIAction]()
        
        for sort in sortOptions.allCases {
            sortoptions.append(UIAction(title: "\(sort.title)", image: nil, identifier: .none, discoverabilityTitle: "Sort Options", attributes: [], state: .on, handler: {_ in
                
                fetchNotes(tag: self.currentTag, sortOption: sort)
                
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
                
            }))
        }
        
        for view in viewOptions.allCases {
            viewoptions.append(UIAction(title: "\(view.title)", image: UIImage(systemName: "\(view.icon)"), identifier: .none, discoverabilityTitle: "View Options", attributes: [], state: .on, handler: {_ in
                
               print("FLLFLFLFL")
                
            }))
        }
        
        
        let sortOptionsMenu = UIMenu(title: "", subtitle: nil, image: nil, identifier: nil, options: .displayInline, children: sortoptions)
        
        let viewOptionsMenu = UIMenu(title: "", subtitle: nil, image: nil, identifier: nil, options: .displayInline, children: viewoptions)
        
        return UIMenu(title: "View Options", image: nil, identifier: nil, options: .singleSelection, children: [viewOptionsMenu, sortOptionsMenu])
        
    }
    
    @objc func reloadNotesTable(notification: Notification) {
        guard let rowNum = notification.userInfo!.values.first as? Int else { return }
        tableView.reloadRows(at: [IndexPath(item: rowNum, section: 0)], with: .fade)
    }
    
    func presentFolderView(service: SharingLocation) {
        let vc = FolderLocationViewController()
        let navController = UINavigationController(rootViewController: vc)
        vc.serviceType = .download
        vc.location = service
        
        present(navController, animated: true)
        
        vc.returnPDFData = { file in
            
            let newPDF = PDFDocument(data: file)
            
            self.addNewNote(thumbnail: (newPDF!.page(at: 0)?.createThumbnail())!, pdf: newPDF!.dataRepresentation()!)
            
        }
    }
}

extension ViewController: UIDocumentPickerDelegate {
    @objc func presentFilesPicker() {
        let documentpicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf, UTType.data])
        documentpicker.delegate = self
            self.present(documentpicker, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let myURL = urls.first else {
            return
        }
        
        myURL.startAccessingSecurityScopedResource()
        do {
            let newDoc = PDFDocument(url: myURL)
            print(newDoc?.pageCount)
            addNewNote(thumbnail: (newDoc?.page(at: 0)!.createThumbnail())!, pdf: (newDoc?.dataRepresentation())!)
        } catch {
            print("There was an error loading the image: \(error). Please try again.")
        }
        
        myURL.startAccessingSecurityScopedResource()
        
    }
}

extension ViewController: VNDocumentCameraViewControllerDelegate {
    @objc func presentDocumentScanner() {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        let errorAlert = UIAlertController(title: "Failed to scan document", message: "The document couldn't be scanned right now. Please try again.", preferredStyle: .alert)
        
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(errorAlert, animated: true)
        
        controller.dismiss(animated: true)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewController(_ controller:            VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        // Process the scanned pages
        let newPDF = PDFDocument()
        for pageNumber in 0..<scan.pageCount {
            newPDF.insert(PDFPage(image: scan.imageOfPage(at: pageNumber))!, at: pageNumber)
        }
        
        controller.dismiss(animated: true)
        addNewNote(thumbnail: (newPDF.page(at: 0)?.createThumbnail())!, pdf: newPDF.dataRepresentation()!)
    }
}
