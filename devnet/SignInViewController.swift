//
//  LoginViewController.swift
//  devnet
//
//  Created by Zulwiyoza Putra on 1/18/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit



class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // VARIABLES
    
    var appDelegate: AppDelegate!
    
    // OUTLETS
    
    // Facebook Login Button Instance
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    // LOGIN AND LOGOUT SETUP FOR FACEBOOK
    
    // Handling for if login complete
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        // Was there any error occurs?
        guard (error == nil) else {
            print("Could not sign in to Facebook with error: ", error)
            return
        }
        
        signInRequest()
        
        print("Successfully logged in from Facebook")

    }
    
    // Handling for if login complete
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Successfully logged out from Facebook")
    }
    
    
    // Taking out data
    private func signInRequest() -> Void {
        
        // Do we have access Token?
        guard let accessToken = FBSDKAccessToken.current(), let stringAccessToken = accessToken.tokenString else {
            print("No access token")
            return
        }
        
        // Login with firebase
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: stringAccessToken)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
        
            // Was there any error?
            guard (error == nil) else {
                print("There was an error occurs")
                return
            }
            
            // Do we have any user information
            guard let user = user else {
                print("There was no error information")
                return
            }
            
            print("Successfully login with \(user)")
            
        })
        
        
        // Taking out id name and email information from Facebook SDK Request
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            guard (error == nil) else {
                print("Failed tos tart a graph request", error!)
                return
            }
            
            guard let result = result else {
                print(error!)
                return
            }
            
            guard let data: [String:AnyObject] = result as? [String : AnyObject] else {
                print("dfadsfafasf", error!)
                return
            }
            
            guard let userEmail = data["email"] as? String else {
                print("There was no user email returned")
                return
            }
            
            guard let userName = data["name"] as? String else {
                print("There was no user name returned")
                return
            }
            
            guard let userID = data["id"] as? String else {
                print("There was no user id returned")
                return
            }
            
            // Perform storing data on model
            
            User.userName = userName
            User.userEmail = userEmail
            User.userID = userID
            
            performUIUpdatesOnMain {
                self.showAlert()
            }
            
        }
        
    }
    
    // Presenting UI alert view
    private func showAlert() -> Void {
        let alert = UIAlertController(title: "Welcome", message: "Welcome to Devnet, \(User.userName!) with email \(User.userEmail!)", preferredStyle: UIAlertControllerStyle.alert)
        let Ok = UIAlertAction(title: "Ok", style: .destructive) { (alert: UIAlertAction!) in
//            performUIUpdatesOnMain {
//                self.presentNextView()
//            }
        }
        alert.addAction(Ok)
        present(alert, animated: true, completion: nil)
    }

    // APP LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // For Facebook login button
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookLoginButton.delegate = self
        
    }


}

