//
//  InitialViewController.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/23/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func beginLoading() {
        activityIndicator.startAnimating()
    }
    
    func endLoading() {
        activityIndicator.stopAnimating()
    }
    
    func isUserSignedIn(completion: @escaping (_ success: Bool, _ userID: String?) -> Void) {
        if let uid = Firebase.shared().uid {
            
            completion(true, uid)
        } else {
            
            completion(false, nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginLoading()
        
        isUserSignedIn { (isSignIn, userID) in
            
            if isSignIn == true {
                
                guard let uid = userID else { return }
                
                print("User is signed in with uid: ", uid)
                
                self.endLoading()
                
            } else {
                
                print("User is not signed in")
                
                self.endLoading()
                
            }
            
        }
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
