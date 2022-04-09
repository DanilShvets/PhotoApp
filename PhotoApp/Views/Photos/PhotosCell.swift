//
//  PhotosCell.swift
//  PhotoApp
//
//  Created by Данил Швец on 06.04.2022.
//

import UIKit

class PhotosCell: UICollectionViewCell {
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .systemBackground
        image.layer.cornerRadius = 10
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                image.alpha = 0.5
                UIView.animate(withDuration: 0.4) {
                    self.backgroundColor = UIColor(red: 0.97, green: 0.96, blue: 0.95, alpha: 1.00)
                    self.layer.cornerRadius = 10
                    self.clipsToBounds = true
                }
                
            }
            else {
                image.alpha = 1.0
                UIView.animate(withDuration: 0.4) {
                    self.backgroundColor = nil
                    self.layer.cornerRadius = 10
                    self.clipsToBounds = true
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        backgroundColor = UIColor(red: 0.97, green: 0.96, blue: 0.95, alpha: 1.00)
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        image.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        image.clipsToBounds = true
    }
    
    func fillPhotosData(images: UIImage) {
        image.image = images
    }
}
