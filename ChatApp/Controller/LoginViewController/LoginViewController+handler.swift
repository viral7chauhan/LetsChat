//
//  LoginViewController+handler.swift
//  ChatApp
//
//  Created by Viral Chauhan on 23/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Action
    @objc func handleSegmentChange() {
        let currentIndex = loginRegisterSegment.selectedSegmentIndex
        let isLoginSelected = (currentIndex == 0)
        
        //Change label text
        let currentTitleString = loginRegisterSegment.titleForSegment(at: currentIndex)
        LoginRegisterButton.setTitle(currentTitleString, for: .normal)
        
        //Set height of inputcontainer view
        inputContainerHeightAnchor.constant = isLoginSelected ? 100 : 150
        
        //Hide name textfield
        nameTextHeightAnchor.isActive = false
        nameTextHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: isLoginSelected ? 0 : 1/3)
        nameTextHeightAnchor.isActive = true
        
        //Change height of email field
        emailTextHeightAnchor.isActive = false
        emailTextHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: isLoginSelected ? 1/2 : 1/3)
        emailTextHeightAnchor.isActive = true
        
        //change height of password field
        pwdTextHeightAnchor.isActive = false
        pwdTextHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: isLoginSelected ? 1/2 : 1/3)
        pwdTextHeightAnchor.isActive = true
        
    }
    
    @objc func handleLoginRegister() {
        
        if loginRegisterSegment.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    
    @objc func keyboardShow (notification: Notification) {
        //        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        //            self.scrollContentView.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        //        }
    }
    
    @objc func keyboardHide() {
        //        UIView.animate(withDuration: 0.37, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        //            self.scrollContentView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        //        }, completion: nil)
    }
    
    private func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("form is not completed")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (resutl, error) in
            if let error = error {
                print("Some error occur", error)
                return
            }
            self.messageViewController?.displayTitle()
            self.dismiss(animated: true, completion: {
                self.messageViewController = nil
            })
        }
    }
    
    private func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("form is not completed")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Some error occur", error)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            //Upload image
            self.uploadImage(result: { (url: String) -> (Void) in
                print(url)
                let value = ["name" : name, "email" : email, "profileImageUrl" : url]
                //Register user
                self.registerUserIntoDb(withUid: uid, and: value as [String : AnyObject])
            })
            
        }
    }
    
    private func uploadImage(result: @escaping (String)->(Void)) {
        let imgName = UUID().uuidString
        let storage = Storage.storage().reference().child("profile_image").child("\(imgName).png")
        
        if let img = self.profileImgView.image, let uploadData = UIImageJPEGRepresentation(img, 0.1) {
            storage.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                if let error = error {
                    print(error)
                    return
                }
                storage.downloadURL(completion: { (url, error) in
                    if let url = url?.absoluteString {
                        result(url)
                    }
                })
            })
        }
    }
    
    private func registerUserIntoDb(withUid uid: String, and value: [String:AnyObject]) {
        let userRef = self.firbaseDbRef.child("users").child(uid)
        userRef.updateChildValues(value, withCompletionBlock: { (error, dbRef) in
            if let error = error {
                print("Some error occur", error)
                return
            }
            
            let user = User(with: value)
            self.messageViewController?.setupNavTitleView(user: user)
            self.dismiss(animated: true, completion: {
                self.messageViewController = nil
            })
        })
    }
    
    @objc func handleProfileImageTap() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImageFromPicker = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImageFromPicker
        } else if let originalImageFromPicker = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImageFromPicker
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImgView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}


