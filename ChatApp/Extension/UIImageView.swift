//
//  UIImageView.swift
//  ChatApp
//
//  Created by Viral Chauhan on 23/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func saveImageIntoCacheDisplayOnImageView(imageUrl: String) {
        
        if let url = URL(string: imageUrl) {
            
            self.image = nil
            
            //fetch image from cache
            if let imageFromCache = imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
                self.image = imageFromCache
                return
            }
            
            // fetch image from network
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async {
                    if let imagedata = data, let downloadedImage = UIImage(data: imagedata) {
                        imageCache.setObject(downloadedImage, forKey: imageUrl as AnyObject)
                        self.image = downloadedImage
                    }
                }
            }.resume()
        }
        
    }
}
