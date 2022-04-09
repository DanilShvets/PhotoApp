//
//  FeedCell.swift
//  PhotoApp
//
//  Created by Данил Швец on 06.04.2022.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    private var icon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .systemBackground
        image.clipsToBounds = true
        return image
    }()
    private let username: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        backgroundColor = UIColor(red: 0.97, green: 0.96, blue: 0.95, alpha: 1.00)
        username.font = UIFont.systemFont(ofSize: 30)
        username.textColor = UIColor(red: 0.27, green: 0.32, blue: 0.42, alpha: 1.00)
        let stack = UIStackView(arrangedSubviews: [icon, username])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        icon.heightAnchor.constraint(equalTo: stack.heightAnchor, constant: -10).isActive = true
        icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
    }
    
    func fillCellData(images: UIImage) {
        icon.image = images
        icon.layer.cornerRadius = icon.frame.height / 2
        username.text = "User \(Int.random(in: 1000...5000))"
    }
    
}
