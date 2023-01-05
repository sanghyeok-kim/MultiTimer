//
//  PaddingButton.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/21.
//

import UIKit

final class PaddingButton: UIButton {
    private var padding = UIEdgeInsets.zero
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if contentSize == .zero { return contentSize }
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
