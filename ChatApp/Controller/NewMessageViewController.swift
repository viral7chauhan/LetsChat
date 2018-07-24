//
//  NewMessageViewController.swift
//  ChatApp
//
//  Created by Viral Chauhan on 23/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewMessageViewController: BaseTableViewController<UserCell, User> {

    private var firbaseDbRef: DatabaseReference! = Database.database().reference()//(fromURL: "https://letschat-4d246.firebaseio.com/")
    
    weak var homeViewController: HomeViewController?
    
    deinit {
        print("NewMessageViewController Deinit-----")
    }
    
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
                user.id = snapshot.key
                self.item.append(user)
                DispatchQueue.main.async {
                    print("NewMessageViewController Reload Table")
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.item[indexPath.row]
            if let homeVC = self.homeViewController {
                homeVC.showChatViewControllerWith(user: user)
                self.homeViewController = nil
            }
        }
    }
    
}
