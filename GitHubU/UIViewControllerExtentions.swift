//
//  UIViewControllerExtentions.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorCommonDialog(error: Error) {
        if let serviceError = error as? CommonServiceError {
            switch serviceError {
            case .connectionMissing:
                UIAlertController.showError(in: self, message: "common__error__connection_problem")
            case .limitExceeded(let until):
                if let until = until {
                    let timeFormatter = DateFormatter()
                    timeFormatter.timeStyle = DateFormatter.Style.short
                    let untilDate = timeFormatter.string(from: until)
                    let message = String(format:NSLocalizedString("common__error__limit_exceeded__try_after", comment: ""), untilDate)
                    UIAlertController.showError(
                        in: self,
                        localizedTitle: NSLocalizedString("common__title__error", comment: ""),
                        localizedMessage: message
                    )
                }
                else {
                    UIAlertController.showError(in: self, message: "common__error__limit_exceeded__try_later")
                }
            }
        }
        else {
            UIAlertController.showError(in: self, message: "common__error__unexpected")
        }
    }
}
