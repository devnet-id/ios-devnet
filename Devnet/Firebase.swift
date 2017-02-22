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
    
    var databaseRef = FIRDatabase.database().reference(fromURL: "https://devnet-12ce3.firebaseio.com/")
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
    
    class func getUser(_ completion: @escaping (_ success: Bool,_ dictionary: [String: AnyObject]?,_ errorString: String?) -> Void) {

        let ref = Firebase.shared().databaseRef
        let uid = Firebase.shared().uid
        
        ref.child("users").child(uid!).observe(.value, with: { (dataSnapshot) in
            
            guard let dictionary = dataSnapshot.value as? [String: AnyObject] else {
                completion(false, nil, "There was no dictionary returned")
                return
            }
            
            completion(true, dictionary, nil)
        })

    }
    
    class func postUser(dictionary: [String: AnyObject], _ completion: @escaping (_ success: Bool,_ errorString: String?) -> Void) {
        
        let ref = Firebase.shared().databaseRef
        let uid = Firebase.shared().uid
        
        ref.child("users").child(uid!).updateChildValues(dictionary) { (firebaseDatabaseError, firebaseDatabaseRef) in
            
            guard firebaseDatabaseError != nil else {
                completion(false, firebaseDatabaseError.debugDescription)
                return
            }
            
            completion(true, nil)
            
        }
    }
    
    class func shared() -> Firebase {
        struct Singleton {
            static var sharedInstance = Firebase()
        }
        return Singleton.sharedInstance
    }
}
