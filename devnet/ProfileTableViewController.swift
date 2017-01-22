//
//  ProfileViewController.swift
//  devnet
//
//  Created by Zulwiyoza Putra on 1/20/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class ProfileTableViewController: UITableViewController {

    @IBAction func signOutButton(_ sender: Any) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
