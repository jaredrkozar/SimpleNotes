//
//  ChangeDateViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 6/18/22.
//

import UIKit

class ChangeDateViewController: UIViewController {

    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Change Note Date"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.backgroundColor = .systemGray6
      
        let datePicker = UIDatePicker(frame: view.bounds)
        datePicker.contentVerticalAlignment = .bottom
          // Posiiton date picket within a view
        datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false
          
          // Set some of UIDatePicker properties
          datePicker.timeZone = NSTimeZone.local
          
          // Add an event to call onDidChangeDate function when value is changed.
     
          // Add DataPicker to the view
          self.view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            datePicker.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 700),
            datePicker.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    @objc func cancelButton() {
        dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
