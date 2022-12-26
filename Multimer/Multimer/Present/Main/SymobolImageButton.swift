//
//  SymobolImageButton.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/18.
//

import UIKit

final class SymobolImageButton: UIButton {
    init(size: CGFloat, systemName: String, color: UIColor) {
        super.init(frame: .zero)
        let buttonImage = UIImage.makeSFSymbolImage(size: size, systemName: systemName, color: color)
        setImage(buttonImage, for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
