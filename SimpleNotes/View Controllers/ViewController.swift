//
//  ViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/8/21.
//

import UIKit
import WSTagsField
import PDFKit

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
        
        let addNote = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addNote))

        let viewOptions = UIBarButtonItem(title: nil, image: UIImage(systemName: "arrow.up.arrow.down"), primaryAction: nil, menu: viewOptionsMenu())
        
        self.navigationItem.rightBarButtonItems = [addNote, viewOptions]
        
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
    
    @objc func addNote(sender: UIBarButtonItem) {
        createNewNote()
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
        guard let path = Bundle.main.url(forResource: "vitb12", withExtension: "pdf") else { return }
        
        vc.pdfDocument = PDFDocument(url: path)
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
}
