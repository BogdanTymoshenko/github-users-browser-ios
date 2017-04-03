//
//  UserRepoViewCell.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import UIKit

class UserRepoViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var seenCountLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var descLabelFont:UIFont = {
        return UIFont.systemFont(ofSize:15.0)
    }()
    
    static func computeContentSize(collectionViewBounds:CGRect, repo:Repo) -> CGSize {
        /*
         
         Cell horizontal scheme
         
         |16 | 16 *card view* 16 | 16|
         
         */
        
        var descBounds = CGRect.zero
        if let descText = repo.desc {
            let descriptionMaxWidth = collectionViewBounds.width - 16 - 16 - 16 - 16
            
            descBounds = NSString(string: descText).boundingRect(
                with: CGSize(width:descriptionMaxWidth, height:0),
                options:NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName:descLabelFont],
                context: nil)
        }
        
        /*
         
          Cell vertical scheme
         ___
         8
         ___
         
         16
         
         *card view*
         
         21 - name label height
         
         15 - margin if desc label not empty
         
         ? - desc label height
         
         15
         
         16 - counters container
         
         16
         ___
         
         8
         ___
         
         */
        
        let descLabelWithMargin = descBounds.height + (descBounds.height > 0 ? 15 : 0)
        let contentHeight = 8 + 16 + 21 + descLabelWithMargin + 15 + 16 + 16 + 8
        
        return CGSize(width: collectionViewBounds.width, height: contentHeight)
    }

}
