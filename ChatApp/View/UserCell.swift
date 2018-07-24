//
//  UserCell.swift
//  ChatApp
//
//  Created by Viral Chauhan on 24/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import UIKit

class UserCell: BaseCell<User> {
    
    override var item: User! {
        didSet {
            textLabel?.text = item.name
            detailTextLabel?.text = item.email
            
            if let profileImgUrl = item.profileImageUrl {
                profileImgView.saveImageIntoCacheDisplayOnImageView(imageUrl: profileImgUrl)
            }
        }
    }
}
