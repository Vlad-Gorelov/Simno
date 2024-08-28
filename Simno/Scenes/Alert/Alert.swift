//
//  Alert.swift
//  Simno
//
//  Created by Владислав Горелов on 28.08.2024.
//

import UIKit

final class AlertHelper {

    static func showDeleteConfirmation(on viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: "AreYouSure".localized, preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Yes".localized, style: .default) { _ in
            completion(true)
        }
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")

        let cancelAction = UIAlertAction(title: "No".localized, style: .default) { _ in
            completion(false)
        }
        cancelAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        viewController.present(alertController, animated: true, completion: nil)
    }
}
