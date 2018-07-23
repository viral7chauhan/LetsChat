//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Viral Chauhan on 19/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    weak var messageViewController: HomeViewController?
    
    var firbaseDbRef: DatabaseReference = Database.database().reference()//(fromURL: "https://letschat-4d246.firebaseio.com/")
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var LoginRegisterButton: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.backgroundColor = Theme.loginButtonBgColor
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return btn
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tag = 1
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tag = 2
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tag = 3
        return tf
    }()
    
    let nameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.loginSepeartorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.loginSepeartorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = #imageLiteral(resourceName: "angry")
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap)))
        return imgView
    }()
    
    let bgScrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let scrollContentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let loginRegisterSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Login", "Register"])
        segment.tintColor = .white
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 1
        segment.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segment
    }()
    
    var inputContainerHeightAnchor: NSLayoutConstraint!
    var nameTextHeightAnchor: NSLayoutConstraint!
    var emailTextHeightAnchor: NSLayoutConstraint!
    var pwdTextHeightAnchor: NSLayoutConstraint!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        unRegisterObserver()
    }
    
    //MARK: Override
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: Private
    private func setupView() {
        view.backgroundColor = Theme.loginBgColor
        
        view.addSubview(bgScrollView)
        bgScrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(inputContainerView)
        scrollContentView.addSubview(LoginRegisterButton)
        scrollContentView.addSubview(profileImgView)
        scrollContentView.addSubview(loginRegisterSegment)

        [nameTextField, emailTextField, passwordTextField].forEach { (textField) in
            textField.delegate = self
        }
        bgScrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
        setAutoLayoutContrains()
        
    }
    
    private func setAutoLayoutContrains() {
        setupBgScrollView()
        setupInputContainerView()
        setupLoginRegisterButtonView()
        setupProfileImageView()
        setupLoginRegisterSegmentControl()
    }
    
    fileprivate func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide , object: nil)
    }
    
    fileprivate func unRegisterObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    
    
    //MARK: TextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag+1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    
}



extension LoginViewController {
    
    //MARK: Autolayout
    fileprivate func setupBgScrollView() {
        bgScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bgScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bgScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bgScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scrollContentView.heightAnchor.constraint(equalTo: bgScrollView.heightAnchor).isActive = true
        scrollContentView.widthAnchor.constraint(equalTo: bgScrollView.widthAnchor).isActive = true
    }
    
    fileprivate func setupProfileImageView() {
        //Center X, Y, Width and height
        profileImgView.centerXAnchor.constraint(equalTo: bgScrollView.centerXAnchor).isActive = true
        profileImgView.bottomAnchor.constraint(equalTo: loginRegisterSegment.topAnchor, constant: -12).isActive = true
        profileImgView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImgView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    fileprivate func setupLoginRegisterSegmentControl() {
        loginRegisterSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegment.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegment.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegment.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    
    fileprivate func setupInputContainerView() {
        //Center X, Y, Width and height
        inputContainerView.centerXAnchor.constraint(equalTo: bgScrollView.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: bgScrollView.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: bgScrollView.widthAnchor, constant: -24).isActive = true
        inputContainerHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerHeightAnchor.isActive = true
        
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeperatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeperatorView)
        inputContainerView.addSubview(passwordTextField)
        
        setupNameTextField()
        setupNameSeperatorView()
        setupEmailTextField()
        setupEmailSeperatorView()
        setupPasswordTextField()
    }
    
    fileprivate func setupNameTextField() {
        //Center X, Y, Width and height
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        nameTextHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextHeightAnchor.isActive = true
    }
    
    fileprivate func setupEmailTextField() {
        //Center X, Y, Width and height
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailTextHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextHeightAnchor.isActive = true
    }
    
    fileprivate func setupPasswordTextField() {
        //Center X, Y, Width and height
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        pwdTextHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        pwdTextHeightAnchor.isActive = true
    }
    
    fileprivate func setupNameSeperatorView() {
        //Center X, Y, Width and height
        nameSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    fileprivate func setupEmailSeperatorView() {
        //Center X, Y, Width and height
        emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    fileprivate func setupLoginRegisterButtonView() {
        //Center X, Y, Width and height
        LoginRegisterButton.centerXAnchor.constraint(equalTo: bgScrollView.centerXAnchor).isActive = true
        LoginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        LoginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        LoginRegisterButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
}

