//
//  UIAlertControllerExtentions.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func showError(in viewController:UIViewController, title:String = "common__title__error", message:String, onClose:(() -> ())? = nil) {
        showError(
            in: viewController,
            localizedTitle: NSLocalizedString(title, comment: ""),
            localizedMessage: NSLocalizedString(message, comment: ""),
            onClose: onClose
        )
    }
    
    static func showError(in viewController:UIViewController, localizedTitle:String, localizedMessage:String, onClose:(() -> ())? = nil) {
        let alertVC = UIAlertController(
            title: localizedTitle,
            message: localizedMessage,
            preferredStyle: UIAlertControllerStyle.alert)
        alertVC.addAction(
            UIAlertAction(title:NSLocalizedString("common__error__button__okey", comment:""),
                          style:UIAlertActionStyle.default,
                          handler:{ _ in onClose?() }
            )
        )
        viewController.present(alertVC, animated: true, completion: nil)
    }
}

