//
//  UIImageViewExtentions.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {
    func gh_setImage(from url:URL, filter:ImageFilter? = nil, placeHolderFilter:ImageFilter? = nil, placeHolder:UIImage? = nil, loader:ImageDownloader) -> RequestReceipt? {
        self.image = placeHolder
        let request = URLRequest(url: url)
        return loader.download(request, completion: { data in
            switch (data.result) {
            case .success(let image):
                self.setImage(image, withTransition: .crossDissolve(0.25))
            case .failure(let error):
                print("Fail to load image \(error)")
            }
        })
    }
    
    private func setImage(_ image:UIImage, withTransition imageTransition:UIImageView.ImageTransition) {
        UIView.transition(
            with: self,
            duration: imageTransition.duration,
            options: imageTransition.animationOptions,
            animations: { imageTransition.animations(self, image) },
            completion: imageTransition.completion
        )
    }
}

