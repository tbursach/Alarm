//
//  AlarmTableViewController.swift
//  Alarm
//
//  Created by Trevor Bursach on 9/14/20.
//  Copyright © 2020 Trevor Bursach. All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController, SwitchTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        AlarmController.shared.load()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return AlarmController.shared.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
        cell.alarm = AlarmController.shared.alarms[indexPath.row]
        cell.updateViews()
        cell.delegate = self
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            guard let destination = segue.destination as? AlarmDetailTableViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
            destination.alarm = AlarmController.shared.alarms[indexPath.row]
        }
    }
    
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let alarm = cell.alarm else { return }
        AlarmController.shared.toggleEnabled(for: alarm)
        tableView.reloadData()
    }
    
    
    
} //END OF CLASS


