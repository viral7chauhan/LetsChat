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

class HomeViewController: UITableViewController {

    var firbaseDbRef: DatabaseReference = Database.database().reference()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: Private
    private func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeNewMessage))
        
        checkIfUserLoggedIn()
    }
    
    fileprivate func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            self.perform(#selector(handleLogout), with: nil, afterDelay: 0.1)
        } else {
            displayTitle()
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
        loginVC.messageViewController = self
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc func composeNewMessage() {
        let nav = UINavigationController(rootViewController: NewMessageViewController())
        present(nav, animated: true, completion: nil)
    }

    
    //MARK: Public
    
    func displayTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        var handle: UInt = 0
        handle = firbaseDbRef.child("users").child(uid).observe(.value) { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let name = dictionary["name"] as? String {
                    print("Logged Uesr \(name)")
                    self.firbaseDbRef.removeObserver(withHandle: handle)
                    
                    DispatchQueue.main.async {
                        let user = User(with: dictionary)
                        self.setupNavTitleView(user: user)
                    }
                }
            }
        }
    }
    
    
    public func setupNavTitleView(user: User) {
        let navTitleView = UIView()
        navTitleView.backgroundColor = .red
        navTitleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        navTitleView.addSubview(containerView)
        
        guard let profileImgUrl = user.profileImageUrl else {
            return
        }
        
        let profileImgView = UIImageView()
        profileImgView.translatesAutoresizingMaskIntoConstraints = false
        profileImgView.saveImageIntoCacheDisplayOnImageView(imageUrl: profileImgUrl)
        containerView.addSubview(profileImgView)
        
        profileImgView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        profileImgView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImgView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImgView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImgView.layer.cornerRadius = 20
        profileImgView.layer.masksToBounds = true
        
        guard let name = user.name else {
            return
        }
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = name
        titleLabel.backgroundColor = .clear
        containerView.addSubview(titleLabel)
        
        titleLabel.leftAnchor.constraint(equalTo: profileImgView.rightAnchor, constant: 8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: profileImgView.centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: profileImgView.heightAnchor).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo: navTitleView.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: navTitleView.centerXAnchor).isActive = true
        
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileIcon)))
        self.navigationItem.titleView = navTitleView
    }
    
    
    //MARK: Action
    @objc func handleProfileIcon() {
        print(123)
        let chatVc = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatVc, animated: true)
    }
    
    
}
