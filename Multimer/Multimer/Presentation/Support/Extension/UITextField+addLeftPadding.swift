//
//  UITextField+addLeftPadding.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/16.
//

import UIKit

extension UITextField {
  func addLeftPadding(inset: Double) {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: self.frame.height))
      leftViewMode = .always
      leftView = paddingView
  }
}
