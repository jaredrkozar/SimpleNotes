//
//  TabBarController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/23/22.
//

import UIKit

class TabBarController: UITabBarController {

    private lazy var allNotesViewController = makeViewController()
    private lazy var tagsTableViewController = makeTagsTableViewController()
    private lazy var settingsViewController = makeSettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [allNotesViewController,
                           tagsTableViewController, settingsViewController]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndex = 0
    }

}

private extension TabBarController {

    private func makeViewController() -> UINavigationController {
        let vc = ViewController()
        vc.tabBarItem = UITabBarItem(title: "Notes",
                                     image: UIImage(systemName: "square.grid.2x2.fill"),
                                     tag: 0)

        return UINavigationController(rootViewController: vc)
    }

    private func makeTagsTableViewController() -> UINavigationController {
        let vc = TagsTableViewController()
        vc.tabBarItem = UITabBarItem(title: "Tags",
                                     image: UIImage(systemName: "tag.fill"),
                                     tag: 1)
        return UINavigationController(rootViewController: vc)
    }
    
    private func makeSettingsViewController() -> UINavigationController {
        let vc = SettingsViewController()
        vc.tabBarItem = UITabBarItem(title: "Settings",
                                     image: UIImage(systemName: "gear"),
                                     tag: 2)
        return UINavigationController(rootViewController: vc)
    }
}
