//
//  UserCellViewTableViewCell.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import UIKit
import AlamofireImage

class UserViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    
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
