//
//  ViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/8/21.
//

import UIKit

class ViewController: UITableViewController, UINavigationControllerDelegate {
    
    var dataSource = ReusableTableView()
    var currentTag: String?
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name( "tintColorChanged"), object: nil)
    }
    
    func viewAppeared() {
        fetchNotes(tag: currentTag, sortOption: .titleAscending)
        
        tableView.dataSource = dataSource
        dataSource.listofnotes = notes
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentDevice == .iphone || self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact {
            viewAppeared()
        }
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
    
    @objc func tintColorChanged(notification: Notification) {
 
        navigationController?.navigationBar.tintColor = UIColor(hex: (UserDefaults.standard.string(forKey: "tintColor") ?? UIColor.systemBlue.toHex)!)
  
        self.view.tintColor = UIColor(hex: (UserDefaults.standard.string(forKey: "tintColor") ?? UIColor.systemBlue.toHex)!)
    }
    
    @objc func addNote(sender: UIBarButtonItem) {
        createNewNote()
        fetchNotes(tag: nil, sortOption: .titleAscending)
        tableView.dataSource = dataSource
        dataSource.listofnotes = notes
        tableView.reloadData()
        showNote(noteIndex: notes.count - 1)
        print(notes.count)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fetchNoteLockedStatus(index: indexPath.row) == true {
           
            LockNote().authenticate(title: "View this note", onCompleted: {result, error in
                if error == nil {
                    self.showNote(noteIndex: indexPath.row)
                } else {
                    ToastNotification().showToast(backgroundColor: .systemBlue, image: UIImage(systemName: "pin")!, titleText: "DDDD", subtitleText: "DLDLDLDLD", progress: nil)
                }
            })
            
        } else {
            showNote(noteIndex: indexPath.row)
        }
        
       
    }
    
    func showNote(noteIndex: Int?) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newNoteVC") as! NoteViewController
        vc.noteIndex = noteIndex
        vc.isNoteLocked = fetchNoteLockedStatus(index: noteIndex!)
    
        switch currentDevice {
        case .ipad, .mac:
            self.splitViewController?.setViewController(vc, for: .secondary)
        
            self.showDetailViewController(vc, sender: true)
        case .iphone:
            self.show(vc, sender: self)
        case .none:
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
                
                  let cellTag = tableView.cellForRow(at: indexPath) as! NoteTableViewCell
                  
                  let vc = EditTagsTableViewController()
                  let navController = UINavigationController(rootViewController: vc)
                  vc.note = notes[indexPath.row]
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
                                
                                self.dataSource.listofnotes.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                            } else {
                                ToastNotification().showToast(backgroundColor: .systemBlue, image: UIImage(systemName: "pin")!, titleText: "DDDD", subtitleText: "DLDLDLDLD", progress: nil)
                            }
                        })
                        
                    } else {
                        deleteNote(index: indexPath.row)
                        
                        self.dataSource.listofnotes.remove(at: indexPath.row)
                        
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
                
                self.tableView.dataSource = self.dataSource
                self.dataSource.listofnotes = notes
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
        self.tableView.reloadData()
    }
}
