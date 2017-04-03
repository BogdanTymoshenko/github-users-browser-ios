//
//  MBProgressHUDExtension.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import UIKit
import MBProgressHUD

extension MBProgressHUD {
    static func show(at controller:UIViewController, text:String = "common__label__loading", animated:Bool = true) -> MBProgressHUD {
        let processView = MBProgressHUD.showAdded(to: controller.view, animated:animated)
        processView.mode = MBProgressHUDMode.indeterminate
        processView.label.text = NSLocalizedString(text, comment: "")
        return processView
    }
}
