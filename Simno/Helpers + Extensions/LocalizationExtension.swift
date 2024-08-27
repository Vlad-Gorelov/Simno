//
//  LocalizationExtension.swift
//  Simno
//
//  Created by Владислав Горелов on 24.08.2024.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
