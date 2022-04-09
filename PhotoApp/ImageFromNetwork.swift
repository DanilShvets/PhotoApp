//
//  ImageFromNetwork.swift
//  PhotoApp
//
//  Created by Данил Швец on 09.04.2022.
//

import UIKit

final class ImageFromNetwork: UIImageView {
    
    func setURL(_ url: URL?) {
        guard let url = url else {
            image = nil
            return
        }
        
        DispatchQueue.global().async {
            var image: UIImage?
            
            if let data = try? Data(contentsOf: url) {
                image = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}
