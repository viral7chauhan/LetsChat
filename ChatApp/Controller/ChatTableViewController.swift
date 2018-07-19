//
//  ChatTableViewController.swift
//  ChatApp
//
//  Created by Viral Chauhan on 19/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatTableViewController: UITableViewController {

//    var ref: DatabaseReference!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        
    }
    
    //MARK: Private
    private func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    
    
    //Mark: Selectors
    @objc func handleLogout() {
        let loginVC = LoginViewController()
        present(loginVC, animated: true, completion: nil)
    }

}
