//
//  SymbolImageButton.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/18.
//

import UIKit

final class SymbolImageButton: UIButton {
    init(size: CGFloat, systemName: String, color: UIColor? = nil) {
        super.init(frame: .zero)
        let buttonImage = UIImage.makeSFSymbolImage(size: size, systemName: systemName, color: color)
        setImage(buttonImage, for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
