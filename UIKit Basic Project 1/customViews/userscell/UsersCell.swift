//
//  CellWithSubTitles.swift
//  UIKit Basic Project 1
//
//  Created by Asal Macbook 1 on 19/05/2020.
//  Copyright © 2020 Mustafa Birat. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {
    
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private  weak var subtitle: UILabel!
    @IBOutlet private weak var companyName: UILabel!
    
    var user: User? {
        didSet {
            populateUser()
        }
    }
    
    private func populateUser() {
        title.text = user?.username
        subtitle.text = user?.email
        
        if let id = user?.id, id % 2 == 0 {
            companyName.isHidden = false
            companyName.text = user?.company.name
        } else {
            companyName.text = ""
            companyName.isHidden = true
        }
    }
    
}
