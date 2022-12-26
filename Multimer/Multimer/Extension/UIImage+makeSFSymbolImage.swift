//
//  UIImage+makeSFSymbolImage.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/26.
//

import UIKit

extension UIImage {
    static func makeSFSymbolImage(size: CGFloat, systemName: String, color: UIColor? = nil) -> UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: size)
        
        let image = UIImage(
            systemName: systemName,
            withConfiguration: imageConfig
        )?.withTintColor(color ?? .label, renderingMode: .alwaysOriginal)
        
        return image
    }
}
