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
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: size)
        
        let playImage = UIImage(
            systemName: systemName,
            withConfiguration: imageConfig
        )?.withTintColor(color, renderingMode: .alwaysOriginal)
        
        playImage?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        setImage(playImage, for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
