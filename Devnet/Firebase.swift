//
//  Firebase.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/23/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import Firebase

class Firebase: NSObject {
    
    var ref = FIRDatabase.database().reference(fromURL: "https://devnet-12ce3.firebaseio.com/")
    
    
    var uid = FIRAuth.auth()?.currentUser?.uid
    
    class func sharedInstance() -> Firebase {
        struct Singleton {
            static var shared = Firebase()
        }
        return Singleton.shared
    }
    
}
