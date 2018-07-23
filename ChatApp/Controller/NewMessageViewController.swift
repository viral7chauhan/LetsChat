//
//  NewMessageViewController.swift
//  ChatApp
//
//  Created by Viral Chauhan on 23/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewMessageViewController: BaseTableViewController<NewChatCell, User> {

    var firbaseDbRef: DatabaseReference = Database.database().reference()//(fromURL: "https://letschat-4d246.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchUsers()
    }
    
    private func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    }
    
    private func fetchUsers() {
        firbaseDbRef.child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:Any] {
                let user = User(with: dictionary)
                self.item.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}


class NewChatCell: BaseCell<User> {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImgView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 24
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImgView)
        profileImgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImgView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImgView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImgView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
