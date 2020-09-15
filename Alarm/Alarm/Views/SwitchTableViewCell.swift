//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Trevor Bursach on 9/14/20.
//  Copyright © 2020 Trevor Bursach. All rights reserved.
//

import UIKit
protocol SwitchTableViewCellDelegate: AnyObject {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
    }

class SwitchTableViewCell: UITableViewCell   {
    
    weak var delegate: SwitchTableViewCellDelegate?
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmTitleLabel: UILabel!
    @IBOutlet weak var alarmButton: UISwitch!
    
    
    
    @IBAction func enableAlarmButton(_ sender: Any) {
        if let delegate = delegate {
            delegate.switchCellSwitchValueChanged(cell: self)
        }
    }
    
    //MARK: - Helper Functions
    func updateViews() {
        guard let alarm = alarm else { return }
        timeLabel.text = alarm.fireTimeAsString
        alarmTitleLabel.text = alarm.name
        alarmButton.isOn = alarm.enabled
    }
}
