//
//  User.swift
//  ChatApp
//
//  Created by Viral Chauhan on 23/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import Foundation

class User {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return }
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
