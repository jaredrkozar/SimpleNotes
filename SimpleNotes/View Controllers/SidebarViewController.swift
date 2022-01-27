//
//  SidebarViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/23/22.
//

import UIKit

class SidebarViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    private var collectionView: UICollectionView! = nil
    private var supplementaryViewControllers = [UINavigationController(rootViewController: ViewController())
    
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "VisionText"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureHierarchy()
        fetchTags()
        
        NotificationCenter.default.addObserver(self, selector: #selector(configureDataSource(_:)), name: NSNotification.Name( "configureDataSource"), object: nil)
        NotificationCenter.default.post(name: Notification.Name( "configureDataSource"), object: nil)
        
        setInitialSecondaryView()

    }
    
    private func setInitialSecondaryView() {
        collectionView.selectItem(at: IndexPath(row: 0, section: 0),
                                  animated: false,
                                  scrollPosition: UICollectionView.ScrollPosition.centeredVertically)
        splitViewController?.setViewController(supplementaryViewControllers[0], for: .supplementary)
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
            var config = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
            

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
                    tagsItems.append(Item(title: tag.name, image: tag.symbol!.toImage()))
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
        
        print("DDDD")
        
        if indexPath.section == 1 {

            let tag = tagsItems[indexPath.row - 1]
            currentTag = "DDDDDDLLDLDLD"
            view.window?.windowScene?.title = "Filtering by \(String(describing: tag.title))"
        } else {
            view.window?.windowScene?.title = "All Notes"
            currentTag = "folder"
        }
        
        splitViewController?.setViewController(supplementaryViewControllers[0], for: .supplementary)
    }

}

// MARK: - Structs and sample data

struct Item: Hashable {
    let title: String?
    let image: UIImage?
    private let identifier = UUID()
}

var tabsItems = [Item(title: "Notes", image: UIImage(systemName: "square.grid.2x2.fill"))
                ]

var tagsItems = [Item]()


enum Section: String {
    case tabs
    case tags = "Tags"
}
