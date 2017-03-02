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
    
    class func getUser(uid: String,_ completion: @escaping (_ dictionary: [String: AnyObject]?,_ errorString: String?) -> Void) {
        databaseRef.child("users").child(uid).child("user").observe(.value, with: { (dataSnapshot) in
            guard let dictionary = dataSnapshot.value as? [String: AnyObject] else {
                completion(nil, "There was no dictionary returned")
                return
            }
            
            print(dictionary)
            
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
    
    class func getPost(uid: String, completion: @escaping (_ posts: [Post]?) -> Void) {
        var fetchedPosts: [Post]? = []
        
        databaseRef.child("posts").child(uid).observe(.childAdded, with: { (snapshot) in
            if let postDictionary = snapshot.value as? [String: AnyObject] {
                
                let post = Post()
                print(postDictionary)
                
                post.setValuesForKeys(postDictionary)
                
                getUser(uid: uid, { (dictionary, error) in
                    if error == nil {
                        print("SUCCESSFULLY GET USER DICTIONARY")
                        print(dictionary!)
                        let user = User(dictionary: dictionary!)
                        post.user = user
                    }
                })
                
                fetchedPosts?.append(post)
                completion(fetchedPosts)
                
                
            }
            completion(nil)
        })
    }
}
