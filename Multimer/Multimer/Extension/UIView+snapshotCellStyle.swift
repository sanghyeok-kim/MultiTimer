//
//  UIView+snapshotCellStyle.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import UIKit

extension UIView {
    func snapshotCellStyle() -> UIView {
        let image = snapshot()
        let cellSnapshot = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        return cellSnapshot
    }
    
    private func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
