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

class HomeViewController: BaseTableViewController<MessageCell, Message> {

    var firbaseDbRef: DatabaseReference = Database.database().reference()
    private var messsageDictionary = [String:Message]()
    
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
        observerMessages()
    }
    
    fileprivate func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            self.perform(#selector(handleLogout), with: nil, afterDelay: 0.1)
        } else {
            displayTitle()
        }
    }
    
    private func observerMessages() {
        
        firbaseDbRef.child("message").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String:Any] {
                if let message = Message(with: dictionary) {
//                    self.item.append(message)
                    if let toId = message.toId {
                        self.messsageDictionary[toId] = message
                        self.item = Array(self.messsageDictionary.values)
                        
                        self.item.sort(by: { (m1, m2) -> Bool in
                            return m1.timestamp!.intValue > m2.timestamp!.intValue
                        })
                    }
                }
            }
            
            DispatchQueue.main.async {
                print("Reload Called")
                self.tableView.reloadData()
            }
            
        }, withCancel: { (error) in 
            print("WithCencel call")
        })
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
        let newMessageVc = NewMessageViewController()
        newMessageVc.homeViewController = self
        let nav = UINavigationController(rootViewController: newMessageVc)
        present(nav, animated: true, completion: nil)
    }

    
    
    //MARK: Public
    
    func displayTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        firbaseDbRef.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let name = dictionary["name"] as? String {
                    print("Logged Uesr \(name)")
                    
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
        
        self.navigationItem.titleView = navTitleView
    }
    
    
    func showChatViewControllerWith(user: User) {
        let chatVc = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatVc.user = user
        navigationController?.pushViewController(chatVc, animated: true)
    }
    
}

