//
//  StringsExtension.swift
//  PhotoApp
//
//  Created by Данил Швец on 04.04.2022.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
