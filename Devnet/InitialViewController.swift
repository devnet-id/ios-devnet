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
    
    func SignInView() -> UINavigationController {
        let signInViewStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
        let signInView = signInViewStoryboard.instantiateViewController(withIdentifier: "SignIn") as! UINavigationController
        return signInView
    }
    
    func MainView() -> UITabBarController {
        let mainViewStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = mainViewStoryboard.instantiateViewController(withIdentifier: "Main") as! UITabBarController
        return mainView
    }
    
    func handleView() {
        
        beginLoading()
        
        isUserSignedIn { (isSignIn, userID) in
            
            if isSignIn == true {
                
                guard let uid = userID else { return }
                
                print("User is signed in with uid: ", uid)
                
                DispatchQueue.main.async {
                    self.endLoading()
                    self.present(self.MainView(), animated: true, completion: nil)
                    
                }
                
            } else {
                
                print("User is not signed in")
                
                DispatchQueue.main.async {
                    self.endLoading()
                    self.present(self.SignInView(), animated: true, completion: nil)
                }
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handleView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
