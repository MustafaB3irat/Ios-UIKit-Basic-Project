//
//  AlbumHeader.swift
//  UIKit Basic Project 1
//
//  Created by Asal Macbook 1 on 21/05/2020.
//  Copyright © 2020 Mustafa Birat. All rights reserved.
//

import UIKit

class AlbumHeader: UICollectionReusableView {
    @IBOutlet private weak var albumId: UILabel!
    var albumIdText: String = "" {
        didSet {
            self.albumId.text = albumIdText
        }
    }
}
