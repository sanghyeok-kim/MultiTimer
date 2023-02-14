//
//  PaddingButton.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/21.
//

import UIKit

final class PaddingButton: UIButton {
    
    private let padding: UIEdgeInsets
    private let isRounded: Bool
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if contentSize == .zero { return contentSize }
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    init(padding: UIEdgeInsets = .zero, isRounded: Bool = false) {
        self.isRounded = isRounded
        self.padding = padding
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect.inset(by: padding))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRounded {
            self.clipsToBounds = true
            self.layer.cornerRadius = min(self.frame.width, self.frame.height) / 2
        }
    }
}
