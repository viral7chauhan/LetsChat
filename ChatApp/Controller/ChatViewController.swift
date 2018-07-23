//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Viral Chauhan on 23/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import UIKit

class ChatViewController : UICollectionViewController {
    
    let inputViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    }
    
}

