//
//  photoCollectionViewCell.swift
//  UIKit Basic Project 1
//
//  Created by Asal Macbook 1 on 19/05/2020.
//  Copyright © 2020 Mustafa Birat. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {

  @IBOutlet private weak var photo: UIImageView!

    func loadImage(_ url: String) {
        photo.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "default"))
    }
  
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image  = nil
    }
}
