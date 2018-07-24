//
//  Message.swift
//  ChatApp
//
//  Created by Viral Chauhan on 24/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import Foundation

class Message {
    var fromId: String?
    var toId: String?
    var text: String?
    var timestamp: NSNumber?
    
    init?(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return nil }
        fromId = dictionary["fromId"] as? String
        toId = dictionary["toId"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
     }
}
