//
//  TimePickerViewDelegate.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import UIKit

final class TimePickerViewDelegate: NSObject, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let time = TimeType.allCases[component].range[row]
        return String(format: "%3d", time)
    }
}
