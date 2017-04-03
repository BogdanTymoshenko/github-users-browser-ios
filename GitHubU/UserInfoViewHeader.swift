//
//  UserInfoViewHeader.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import UIKit
import AlamofireImage

class UserInfoViewHeader: UICollectionReusableView {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var companyAndLocationLabel: UILabel!
    
    let imageDownloader = ImageDownloader.default
    var imageDownloadRequest:RequestReceipt? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.applyCircleMask()
    }
    
    func setAvatarUrl(url:URL?) {
        if let request = imageDownloadRequest {
            imageDownloader.cancelRequest(with: request)
        }
        
        if let url = url {
            imageDownloadRequest = avatarImageView.gh_setImage(from: url, loader: imageDownloader)
        }
        else {
            avatarImageView.image = nil
        }
    }
}
