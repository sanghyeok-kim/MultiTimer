//
//  RingtoneViewCell.swift
//  Multimer
//
//  Created by 김상혁 on 2023/08/02.
//

import UIKit

final class RingtoneViewCell: UITableViewCell, CellIdentifiable {
    
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        accessoryType = isSelected ? .checkmark : .none
    }
    
    func toggleSelection() {
        accessoryType = isSelected ? .none : .checkmark
    }
}

// MARK: - UI Layout

private extension RingtoneViewCell {
    func layoutUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
