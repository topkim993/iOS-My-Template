//
//  SearchImageCollectionViewCell.swift
//  Template
//
//  Created by Topkim on 2020/01/18.
//  Copyright © 2020 Top Kim. All rights reserved.
//

import UIKit
import Kingfisher

class SearchImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    var imgUrl: String! {
        didSet {
            let url = URL(string: imgUrl)!
            imageView.kf.setImage(
                with: url
            )
        }
    }
}
