//
//  Firebase.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/23/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import Foundation
import Firebase

class Firebase {
    
    static let databaseRef = FIRDatabase.database().reference(fromURL: "https://devnet-12ce3.firebaseio.com/")
    static let storageRef = FIRStorage.storage().reference()
    
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
    
    class func postFollow(uid: String, uidToFollow: String, dictionary: [String: AnyObject], completion: @escaping () -> Void) {
        databaseRef.child("users").child(uid).child("following").child(uidToFollow).updateChildValues(dictionary)
        completion()
    }
    
    class func removeFollow(uid: String, uidToUnfollow: String, completion: @escaping () -> Void) {
        databaseRef.child("users").child(uid).child("following").child(uidToUnfollow).parent?.removeValue()
        completion()
    }
    
    class func getUser(uid: String,_ completion: @escaping (_ dictionary: [String: AnyObject]?,_ errorString: String?) -> Void) {
        
        databaseRef.child("users").child(uid).child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                completion(nil, "There was no dictionary returned")
                return
            }
            completion(dictionary, nil)
        })
    }
    
    class func postUser(uid: String, dictionaryToPost: [String: AnyObject], _ completion: @escaping (_ errorString: String?) -> Void) {
        databaseRef.child("users").child(uid).child("user").updateChildValues(dictionaryToPost) { (firebaseDatabaseError, firebaseDatabaseRef) in
            
            guard firebaseDatabaseError == nil else {
                completion(firebaseDatabaseError.debugDescription)
                return
            }
            completion(nil)
            
        }
    }
    
    class func postPost(uid: String, dictionaryToPost: [String: AnyObject], with completion: @escaping (_ errorMessage: Error?, _ databaseRef: FIRDatabaseReference?) -> Void) {
        
        databaseRef.child("posts").child(uid).childByAutoId().updateChildValues(dictionaryToPost) { (error, reference) in
            if error == nil {
                completion(nil, reference)
            } else {
                completion(error, nil)
            }
        }
    }
}
