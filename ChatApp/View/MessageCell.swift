//
//  MessageCell.swift
//  ChatApp
//
//  Created by Viral Chauhan on 24/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: BaseCell<Message> {
    
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "HH:MM:SS"
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .lightGray
        return lbl
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override var item: Message! {
        didSet {
            
            detailTextLabel?.text = item.text
            if let timestamp = item.timestamp?.doubleValue {
                let date = Date(timeIntervalSince1970: timestamp)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
            
            if let toId = item.toId {
                let ref = Database.database().reference().child("users").child(toId)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        let user = User(with: dictionary)
                        user.id = snapshot.key
                        
                        guard let name = user.name else { return }
                        self.textLabel?.text = name
                        
                        guard let profileUrl = user.profileImageUrl  else { return }
                        self.profileImgView.saveImageIntoCacheDisplayOnImageView(imageUrl: profileUrl)
                    }
                }
            }
            
        }
    }
}
