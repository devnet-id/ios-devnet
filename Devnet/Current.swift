//
//  CurrentUser.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/23/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import Foundation

class Current: NSObject {
    
    var user = User()
        
    class func shared() -> Current {
        struct Singleton {
            static var sharedInstance = Current()
        }
        return Singleton.sharedInstance
    }
    
}
