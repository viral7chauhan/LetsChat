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
import FirebaseAuth

class ChatTableViewController: UITableViewController {

    var firbaseDbRef: DatabaseReference = Database.database().reference()//(fromURL: "https://letschat-4d246.firebaseio.com/")
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        checkIfUserLoggedIn()
    }
    
    //MARK: Private
    private func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    fileprivate func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            self.perform(#selector(handleLogout), with: nil, afterDelay: 0.1)
        } else {
            self.perform(#selector(showTitleWithUserName), with: nil, afterDelay: 0.2)
        }
    }
    
    @objc func showTitleWithUserName() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        print("uid -> \(uid)")
        var handle: UInt = 0
        handle = firbaseDbRef.child("users").child(uid).observe(.value) { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let name = dictionary["name"] as? String {
                    self.navigationItem.title = name
                    print("Logged Uesr \(name)")
                    self.firbaseDbRef.removeObserver(withHandle: handle)
                }
            }
        }
    }
    
    
    //Mark: Selectors
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginVC = LoginViewController()
        present(loginVC, animated: true, completion: nil)
    }

}
