//
//  DefaultTextBoxViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 6/30/22.
//

import UIKit

class DefaultNoteViewController: UITableViewController, UIFontPickerViewControllerDelegate, UIColorPickerViewControllerDelegate {
    var textBoxSettings = [Sections]()
    
    var noteTitle: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .secondarySystemFill
        textfield.layer.cornerRadius = Constants.cornerRadius
        textfield.addTarget(nil, action: #selector(finishedPickingNoteTitle), for: .editingDidEnd)
        textfield.text = UserDefaults.standard.string(forKey: "defaultNoteTitle")
        return textfield
    }()
    
    var defaultNoteDate: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = (UserDefaults.standard.object(forKey: "defaultNoteDate") as? Date)!
        datePicker.addTarget(nil, action: #selector(finishedPickingNoteDate(_:)), for: .editingDidEnd)
        return datePicker
    }()
    
    var colorCircle: UIView = {
        let view = UIView()
        view.sizeToFit()
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = UIColor(hex: (UserDefaults.standard.string(forKey: "defaultTextColor")!))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var defaultPageTypeButton: UIButton = {
        let button = UIButton()
        button.setTitle(UserDefaults.standard.string(forKey: "defaultPageScrollType"), for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Note Defaults"
        self.tableView = UITableView(frame: self.tableView.frame, style: .insetGrouped)
        defaultPageTypeButton.menu = pageScrollTypeMenu()
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
        self.tableView.backgroundColor = .systemGroupedBackground
        
       configureTextBoxSettings()
    }

    // MARK: - Table view data source
    func configureTextBoxSettings() {
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Note Title", option: nil, rowIcon: nil, control: .control(controls: [noteTitle], width: 100), handler: nil)]))
        
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Note Background Color", option: "", rowIcon: nil, control: .color(color: colorCircle), handler: {
                
                self.showColorPicker(popoverPresenter: self.colorCircle, saveTo: "defaultBackgroundColor", vcTitle: "Background Color")
            })
        ]))
        
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Note Date", option: "", rowIcon: nil, control: .control(controls: [defaultNoteDate], width: 200), handler: nil)
        ]))
        
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Note Scroll DIrection", option: "", rowIcon: nil, control: .control(controls: [defaultPageTypeButton], width: 200), handler: nil)
        ]))
    }
                               
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return textBoxSettings.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return textBoxSettings[section].settings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = textBoxSettings[indexPath.section].settings[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowCell", for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the settings cell.")
        }
        
        cell.configureCell(with: setting)
        cell.backgroundColor = .secondarySystemGroupedBackground
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = textBoxSettings[indexPath.section].settings[indexPath.row]
        model.handler?()
    }

    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        let descriptor = viewController.selectedFontDescriptor!
        let font = UIFont(descriptor: descriptor, size: 60)
           
        let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! TableRowCell
        
        cell.optionLabel.text = font.familyName
        UserDefaults.standard.set(font.familyName, forKey: "defaultFont")
        self.tableView.reloadRows(at: [IndexPath(item: 0, section: 1)], with: .automatic)
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        if continuously == false {
            colorCircle.backgroundColor = color
            UserDefaults.standard.set(color.toHex, forKey: "defaultTextColor")
        }
    }
    
    func showColorPicker(popoverPresenter: UIView, saveTo: String, vcTitle: String) {
        let vc = SelectColorPopoverViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        
        if currentDevice == .iphone || self.splitViewController?.traitCollection.horizontalSizeClass == .compact {
            if let picker = navigationController.presentationController as? UISheetPresentationController {
                picker.detents = [.medium()]
                picker.prefersGrabberVisible = true
                picker.preferredCornerRadius = 5.0
            }
        } else if currentDevice == .ipad {
            navigationController.modalPresentationStyle = UIModalPresentationStyle.popover
            navigationController.preferredContentSize = CGSize(width: 270, height: 250)
            navigationController.popoverPresentationController?.sourceItem = popoverPresenter
        } else {
            return
        }
        
        vc.vcTitle = "Note Background Color"
        present(navigationController, animated: true)
        vc.returnColor = { color in
            popoverPresenter.backgroundColor = UIColor(hex: color)
            UserDefaults.standard.set(color, forKey: saveTo)
        }
    }
    
    @objc func finishedPickingNoteTitle() {
        UserDefaults.standard.set(noteTitle.text, forKey: "defaultNoteTitle")
    }
    
    @objc func finishedPickingNoteDate(_ sender: UIDatePicker) {
        UserDefaults.standard.set(sender.date, forKey: "defaultNoteDate")
    }
    
    func pageScrollTypeMenu() -> UIMenu {
        let verticalScroll = UIAction(title: "Vertical", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off) {_ in
            UserDefaults.standard.set(PageDisplayType.vertical, forKey: "defaultPageScrollType")
        }
        
        let horizontalScroll = UIAction(title: "Horizontal", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off) {_ in
            UserDefaults.standard.set(PageDisplayType.horizontal, forKey: "defaultPageScrollType")
        }
        return UIMenu(title: "Page Scroll Direction", image: nil, identifier: nil, options: [.singleSelection], children: [verticalScroll, horizontalScroll])
    }
}
