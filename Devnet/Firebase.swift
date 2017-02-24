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
    
    let databaseRef = FIRDatabase.database().reference(fromURL: "https://devnet-12ce3.firebaseio.com/")
    let storageRef = FIRStorage.storage().reference()
    
    class func firebaseSignOut() -> Void {
        do {
            try FIRAuth.auth()!.signOut()
            Current.shared().user = nil
            print("Successfully signed out")
        } catch let signOutError as NSError {
            print("Error signing out: ", signOutError)
        } catch {
            print("Error signing out with unknown error")
        }
    }
    
    class func firebaseSignIn(email: String, password: String, completion: @escaping (_ userID: String?, _ error: String?) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firebaseUser, firebaseError) in
            guard firebaseError == nil else {
                completion(nil, firebaseError.debugDescription)
                return
            }
            
            guard let firebaseUID = firebaseUser?.uid else {
                completion(nil, "There was no user ID returned from firebase")
                return
            }
            
            completion(firebaseUID, nil)
            
        })
    
    }
    
    class func firebaseSignUp(email: String, password: String,  dictionary: [String: AnyObject], completion: @escaping (_ userID: String?, _ error: String?) -> Void) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (firebaseUser, firebaseError) in
            
            guard firebaseError == nil else {
                completion(nil, firebaseError.debugDescription)
                return
            }
            
            guard let firebaseUID = firebaseUser?.uid else {
                completion(nil, "There was no user ID returned from firebase")
                return
            }
            
            postUser(uid: firebaseUID, dictionaryToPost: dictionary, { (error) in
                
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                
                completion(firebaseUID, nil)
                
            })
        })
    }
    
    class func getUser(_ completion: @escaping (_ dictionary: [String: AnyObject]?,_ errorString: String?) -> Void) {

        let ref = Firebase.shared().databaseRef
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("users").child(uid!).observe(.value, with: { (dataSnapshot) in
            
            guard let dictionary = dataSnapshot.value as? [String: AnyObject] else {
                completion(nil, "There was no dictionary returned")
                return
            }
            
            completion(dictionary, nil)
        })

    }
    
    class func postUser(uid: String, dictionaryToPost: [String: AnyObject], _ completion: @escaping (_ errorString: String?) -> Void) {
        
        let ref = Firebase.shared().databaseRef
        
        ref.child("users").child(uid).updateChildValues(dictionaryToPost) { (firebaseDatabaseError, firebaseDatabaseRef) in
            
            guard firebaseDatabaseError != nil else {
                completion(firebaseDatabaseError.debugDescription)
                return
            }
            
            completion(nil)
            
        }
    }
    
    class func shared() -> Firebase {
        struct Singleton {
            static var sharedInstance = Firebase()
        }
        return Singleton.sharedInstance
    }
}
