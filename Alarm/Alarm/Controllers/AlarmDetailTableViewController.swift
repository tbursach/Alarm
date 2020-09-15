//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Trevor Bursach on 9/14/20.
//  Copyright © 2020 Trevor Bursach. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    var alarmIsOn: Bool = true
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmDescriptionTextField: UITextField!
    @IBOutlet weak var disableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func updateViews() {
        guard let alarm = alarm else { return }
        datePicker.date = alarm.fireDate
        alarmDescriptionTextField.text = alarm.name
        alarmIsOn = alarm.enabled
        disableButtonProperties(for: alarmIsOn)
    }
    
    func disableButtonProperties(for isEnabled: Bool) {
        disableButton.setTitle(isEnabled ? "Disable" : "Enable", for: .normal)
        disableButton.setTitleColor(.white, for: .normal)
        disableButton.backgroundColor = alarmIsOn ? .red : .green
    }
    
    @IBAction func disableButtonWasTapped(_ sender: Any) {
        guard let alarm = alarm else { return }
        alarm.enabled = !alarm.enabled
        print("alarmIsOn: \(alarmIsOn ? "Disable" : "Enable") ")
        updateViews()
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let alarmText = alarmDescriptionTextField.text else { return }
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireDate: datePicker.date, name: alarmText, enabled: alarmIsOn)
        } else {
            let alarm = AlarmController.shared.addAlarm(fireDate: datePicker.date, name: alarmText, enabled: alarmIsOn)
            print(alarm.name)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
} // END OF CLASS
