//
//  User.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/23/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import Foundation
import UIKit

struct User {
    
    var firstName: String?
    var lastName: String?
    var name: String?
    var userName: String?
    var email: String?
    var profileImageURL: String?
    var profileImage: UIImage?
    
    private var session = URLSession.shared
    
    // Initialized using dictionary
    init(dictionary: [String: AnyObject]) {
        
        if let name = dictionary["name"] as? String {
            let arrayFullName = name.components(separatedBy: " ")
            firstName = arrayFullName[0]
            lastName = arrayFullName[1]
            self.name = name
        }
        
        userName = dictionary["userName"] as? String
        
        email = dictionary["email"] as? String
        
        if let url = dictionary["profileImageURL"] as? String {
            
            var imageToInit = UIImage()
            
            self.profileImageURL = url
            getImage(imageURL: url, completion: { (success, image, errorString) in
                
                guard errorString == nil else {
                    print(errorString!)
                    return
                }
                
                if success == true {
                    imageToInit = image!
                }
            })
            
            self.profileImage = imageToInit
            
        } else {
            profileImage = nil
        }
    }
    
    // Initialized using email
    init(username: String, email: String) {
        self.userName = username
        self.email = email
    }
    
    // Initialized using nil properties
    init() {
        firstName = nil
        lastName = nil
        userName = nil
        email = nil
        profileImageURL = nil
        profileImage = nil
    }
    
    // Getting image from network
    private func getImage(imageURL: String, completion
        : @escaping (_ success: Bool?,_ image: UIImage?, _ error: String?) -> Void) {
        
        var image = UIImage()
        
        let url = URL(string: imageURL)
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            guard (error == nil) else {
                completion(false, nil, "There was an error occurs when trying to do data task for get image")
                return
            }
            
            guard let imageData = data else {
                completion(false, nil, "Data returned was nil while getting imageData")
                return
            }
            
            image = UIImage(data: imageData)!
            
            completion(true, image, nil)
            
        }
        
        task.resume()
        
    }
    
}
