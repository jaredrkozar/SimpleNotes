//
//  ChangeDateViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 6/18/22.
//

import UIKit

class ChangeDateViewController: UIViewController, DateHandler {
    
    func dateHandler() -> Date {
        return datePicker.date
    }

    var note: Note?
    
    let datePicker = UIDatePicker()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    var selecteddate: ((_ date: Date)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Change Note Date"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.backgroundColor = .systemGray6

        datePicker.contentVerticalAlignment = .bottom
          // Posiiton date picket within a view
        datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false
          
          // Set some of UIDatePicker properties
          datePicker.timeZone = NSTimeZone.local
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
          // Add an event to call onDidChangeDate function when value is changed.
     
          // Add DataPicker to the view
          self.view.addSubview(datePicker)
        dateLabel.text = "The note's creation date is \(note?.date?.formatted() ?? Date.now.formatted())"
        self.view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            datePicker.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 420),
            datePicker.widthAnchor.constraint(equalToConstant: 300),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            dateLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 5),
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
            dateLabel.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc func cancelButton() {
        dismiss(animated: true)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        dateLabel.text = "The note's creation date is \(String(describing: sender.date.formatted()))"
        selecteddate!(sender.date)
    }
}
