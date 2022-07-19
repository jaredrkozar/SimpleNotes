//
//  SidebarViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/23/22.
//

import UIKit

class SidebarViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    
    private var viewcontroller: ViewController?
    
    private var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "VisionText"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureHierarchy()
        fetchTags()
        NotificationCenter.default.addObserver(self, selector: #selector(configureDataSource(_:)), name: NSNotification.Name( "configureDataSource"), object: nil)
        NotificationCenter.default.post(name: Notification.Name( "configureDataSource"), object: nil)

        
        collectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                         animated: false,
                                         scrollPosition: UICollectionView.ScrollPosition.centeredVertically)
        
        
        let settings = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsScreen))
        
        toolbarItems = [settings]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func settingsScreen() {
        let settingsVC = SettingsViewController()
        
        let navigationController = UINavigationController(rootViewController: settingsVC)
        
        switch currentDevice {
            case .iphone:
                present(navigationController, animated: true)
            case .ipad, .mac:
            let splitView = UISplitViewController(style: .doubleColumn)
            splitView.viewControllers = [navigationController]
            present(splitView, animated: true)
        case .none:
            return
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        #if targetEnvironment(macCatalyst)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        #endif
    }
}

// MARK: - Layout

extension SidebarViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
            

            config.headerMode = section == 0 ? .none : .firstItemInSection
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }
    
    func delete(at ip: IndexPath) {
        var snap = self.dataSource.snapshot()
        if let ident = self.dataSource.itemIdentifier(for: ip) {
            snap.deleteItems([ident])
        }
        self.dataSource.apply(snap)
    }
}

// MARK: - Data

extension SidebarViewController {
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func configureDataSource(_ notification: Notification) {
        // Configuring cells

        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            cell.accessories = [.outlineDisclosure()]
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.image = item.image
            cell.contentConfiguration = content
            cell.accessories = []
        }

        // Creating the datasource

        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            if indexPath.item == 0 && indexPath.section != 0 {
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
                
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
            
            
        }

        // Creating and applying snapshots

        let sections: [Section] = [.tabs, .tags]
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)

        for section in sections {
            switch section {
            case .tabs:
                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
                sectionSnapshot.append(tabsItems)
                dataSource.apply(sectionSnapshot, to: section)
            case .tags:
                var headerItem = Item(title: section.rawValue, image: nil)
                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
                sectionSnapshot.append([headerItem])
               
                tags.compactMap({ tag in
                    tagsItems.append(Item(title: tag.name, image: sendBackSymbol(imageName: tag.symbol!, color: UIColor(hex: tag.color!)!)))
                })
       
                sectionSnapshot.append(tagsItems, to: headerItem)
            
            
                sectionSnapshot.expand([headerItem])
                dataSource.apply(sectionSnapshot, to: section)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension SidebarViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        NotificationCenter.default.post(name: Notification.Name("tintColorChanged"), object: nil)
        
        if indexPath.section != 0 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let navController = UINavigationController(rootViewController: vc)
            vc.currentTag = tagsItems[indexPath.row - 1].title
            vc.viewAppeared()
            self.navigationController?.present(navController, animated: true, completion: nil)
            
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController

            let navController = UINavigationController(rootViewController: vc)
            vc.viewAppeared()
            splitViewController?.setViewController(navController, for: .supplementary)
        }
    
        
    }

}

// MARK: - Structs and sample data

struct Item: Hashable {
    let title: String?
    let image: UIImage?
    private let identifier = UUID()
}

var tabsItems = [Item(title: "Notes", image: UIImage(systemName: "square.grid.2x2.fill"))]

var tagsItems = [Item]()


private enum Section: String {
    case tabs
    case tags = "Tags"
}
