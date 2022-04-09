//
//  ImagesURL.swift
//  PhotoApp
//
//  Created by Данил Швец on 09.04.2022.
//

import Foundation

protocol ImagesURLProtocol {
    func returnURL() -> [ImagesStruct]
}

class ImagesURL: ImagesURLProtocol {
    
    static let shared: ImagesURLProtocol = ImagesURL()
    
    func returnURL() -> [ImagesStruct] {
        return [ImagesStruct.init(imageURL: URL(string: "https://www.cheatsheet.com/wp-content/uploads/2021/07/Kenobi-spoilers.jpg")),
                ImagesStruct.init(imageURL: URL(string: "https://pop.proddigital.com.br/wp-content/uploads/sites/8/2020/12/darth-vader-1.jpg"))]
    }
}

