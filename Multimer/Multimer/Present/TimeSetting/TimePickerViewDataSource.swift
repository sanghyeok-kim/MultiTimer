//
//  TimePickerViewDataSource.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import UIKit

final class TimePickerViewDataSource: NSObject, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return TimeType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TimeType[component].rangeCount
    }
}
