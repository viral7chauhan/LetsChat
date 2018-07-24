//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Viral Chauhan on 23/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController : UICollectionViewController, UITextFieldDelegate {
    
    var user: User? {
        didSet {
            if let username = user?.name {
                navigationItem.title = username
            }
        }
    }
    
    let inputViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var inputTextField : UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter message.."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        return inputTextField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    fileprivate func setupView() {
        collectionView?.backgroundColor = .white
        setupInputViewComponents()
    }
    
    fileprivate func setupInputViewComponents() {
        view.addSubview(inputViewContainer)
        
        inputViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        inputViewContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputViewContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        inputViewContainer.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: inputViewContainer.rightAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: inputViewContainer.topAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: inputViewContainer.bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        inputViewContainer.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: inputViewContainer.leftAnchor, constant: 8).isActive = true
        inputTextField.topAnchor.constraint(equalTo: inputViewContainer.topAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: inputViewContainer.bottomAnchor).isActive = true
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = Theme.loginSepeartorColor
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        inputViewContainer.addSubview(seperatorView)
        
        seperatorView.leftAnchor.constraint(equalTo: inputViewContainer.leftAnchor).isActive = true
        seperatorView.rightAnchor.constraint(equalTo: inputViewContainer.rightAnchor).isActive = true
        seperatorView.topAnchor.constraint(equalTo: inputTextField.topAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    
    @objc func handleSend() {
        
        guard let message = inputTextField.text, let user = user, let toId = user.id  else {
            return
        }
        
        guard let fromId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("message")
        let childRef = ref.childByAutoId()
        
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let value = ["text": message, "toId" : toId, "fromId" : fromId, "timestamp" : timestamp] as [String : Any]
//        childRef.updateChildValues(value)
        
        childRef.updateChildValues(value) { (error, dbRef) in
            if let err = error {
                print("eror \(err)")
                return
            }
            
            let userMsgRef = Database.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            userMsgRef.updateChildValues([messageId:1])
        }
    }
    
    //MARK: UITextfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}

