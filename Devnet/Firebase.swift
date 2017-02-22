//
//  Firebase.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/23/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import Foundation
import Firebase

class Firebase: NSObject {
    
    var databaseRef = FIRDatabase.database().reference(fromURL: "https://circle-e0489.firebaseio.com/")
    var storageRef = FIRStorage.storage().reference()
    var uid = FIRAuth.auth()?.currentUser?.uid
    
    class func firebaseSignOut() -> Void {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    class func firebaseSignIn(email: String, password: String, completion: @escaping (_ success: Bool,_ userID: String?, _ error: String?) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firebaseUser, firebaseError) in
            guard firebaseError == nil else {
                completion(false, nil, firebaseError.debugDescription)
                return
            }
            
            guard let firebaseUID = firebaseUser?.uid else {
                completion(false, nil, "There was no user ID returned from firebase")
                return
            }
            
            completion(true, firebaseUID, nil)
            
        })
    
    }
    
    class func firebaseSignUp(email: String, password: String, completion: @escaping (_ success: Bool,_ userID: String?, _ error: String?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (firebaseUser, firebaseError) in
            guard firebaseError == nil else {
                completion(false, nil, firebaseError.debugDescription)
                return
            }
            
            guard let firebaseUID = firebaseUser?.uid else {
                completion(false, nil, "There was no user ID returned from firebase")
                return
            }
            
            completion(true, firebaseUID, nil)
        })
    }
    
    class func shared() -> Firebase {
        struct Singleton {
            static var sharedInstance = Firebase()
        }
        return Singleton.sharedInstance
    }
}
