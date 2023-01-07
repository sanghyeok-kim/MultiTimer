//
//  CustomColor.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/27.
//

import UIKit

enum CustomColor {
    enum Tag {
        static let checkmarkImage = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 16 / 255, green: 15 / 255, blue: 15 / 255, alpha: 1.0)
            default:
                return UIColor(red: 234 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1.0)
            }
        }
        
        static let label = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 234 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1.0)
            default:
                return UIColor(red: 55 / 255, green: 55 / 255, blue: 55 / 255, alpha: 1.0)
            }
        }
        
        static let red = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 245 / 255, green: 52 / 255, blue: 80 / 255, alpha: 1.0)
            default:
                return UIColor(red: 235 / 255, green: 42 / 255, blue: 70 / 255, alpha: 1.0)
            }
        }
        
        static let orange = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 255 / 255, green: 158 / 255, blue: 98 / 255, alpha: 1.0)
            default:
                return UIColor(red: 250 / 255, green: 141 / 255, blue: 90 / 255, alpha: 1.0)
            }
        }
        
        static let pink = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 255 / 255, green: 171 / 255, blue: 201 / 255, alpha: 1.0)
            default:
                return UIColor(red: 255 / 255, green: 161 / 255, blue: 191 / 255, alpha: 1.0)
            }
        }
        
        static let cyan = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 163 / 255, green: 247 / 255, blue: 227 / 255, alpha: 1.0)
            default:
                return UIColor(red: 100 / 255, green: 206 / 255, blue: 186 / 255, alpha: 1.0)
            }
        }
        
        static let navy = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 106 / 255, green: 136 / 255, blue: 249 / 255, alpha: 1.0)
            default:
                return UIColor(red: 96 / 255, green: 126 / 255, blue: 239 / 255, alpha: 1.0)
            }
        }
        
        static let purple = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 171 / 255, green: 124 / 255, blue: 245 / 255, alpha: 1.0)
            default:
                return UIColor(red: 161 / 255, green: 114 / 255, blue: 225 / 255, alpha: 1.0)
            }
        }
    }
    
    enum ProgressView {
        static let progressTint = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 80 / 255, green: 90 / 255, blue: 120 / 255, alpha: 1.0)
            default:
                return UIColor(red: 203 / 255, green: 213 / 255, blue: 235 / 255, alpha: 0.8)
                
            }
        }
        static let trackTint = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 32 / 255, green: 31 / 255, blue: 35 / 255, alpha: 1.0)
            default:
                return UIColor(red: 220 / 255, green: 230 / 255, blue: 240 / 255, alpha: 0.8)
            }
        }
    }
    
    enum Button {
        static let startImage = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 101 / 255, green: 156 / 255, blue: 255 / 255, alpha: 1.0)
            default:
                return UIColor(red: 47 / 255, green: 85 / 255, blue: 150 / 255, alpha: 1.0)
            }
        }
        
        static let pauseImage = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 150 / 255, green: 192 / 255, blue: 229 / 255, alpha: 1.0)
            default:
                return UIColor(red: 82 / 255, green: 146 / 255, blue: 195 / 255, alpha: 1.0)
            }
        }
        
        static let resetImage = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 244 / 255, green: 172 / 255, blue: 208 / 255, alpha: 1.0)
            default:
                return UIColor(red: 255 / 255, green: 112 / 255, blue: 168 / 255, alpha: 1.0)
            }
        }
        
        static let deleteImage = UIColor(red: 234 / 255, green: 4 / 255, blue: 126 / 255, alpha: 1.0)
    }
    
    enum View {
        static let timerEditing = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .systemGray5
            default:
                return UIColor(red: 224 / 255, green: 230 / 255, blue: 238 / 255, alpha: 1.0)
            }
        }
    }
}
