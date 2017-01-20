//
//  LoginViewController.swift
//  devnet
//
//  Created by Zulwiyoza Putra on 1/18/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    // VARIABLES
    
    var appDelegate: AppDelegate!
    
    // OUTLETS
    
    // Facebook Login Button Instance
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    // Google Sign In Button Instance
    @IBOutlet weak var googleSgnInButton: GIDSignInButton!
    
    
    
    
    
    // LOGIN AND LOGOUT SETUP FOR FACEBOOK
    
    // Handling for if login complete
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        // Was there any error occurs?
        guard (error == nil) else {
            print("Could not sign in to Facebook with error: ", error)
            return
        }
        
        facebookSignInRequest()
        
        print("Successfully logged in from Facebook")

    }
    
    // Handling for if login complete
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("Successfully logged out from Facebook")
    }
    
    
    // Taking out data
    private func facebookSignInRequest() -> Void {
        
        // Setup facebook permission for login button
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
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
    
    
    // LOGIN AND LOG OUT SETUP FOR GOOGLE SIGN IN
    
    // For Google Sign In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard (error == nil) else {
            print("Error sign in with google", error)
            return
        }
        
        guard let idToken = user.authentication.idToken else {
            print("There was no id token returned")
            return
        }
        
        guard let accessToken = user.authentication.accessToken else {
            print("there was no access token returned")
            return
        }
        
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            
            guard (error == nil) else {
                print("Failed to create a Firebase user with Google Account ")
                return
            }
            
            guard let user = user else {
                print("There was no user returned")
                return
            }
            
            User.userID = user.uid
            User.userName = user.displayName
            User.userEmail = user.email
            
            print("successfully logged in with google", User.userID!, User.userName!, User.userEmail!)
            
            performUIUpdatesOnMain {
                self.showAlert()
            }
            
        })
        
    }
    
    // HANDLERS
    
    // Presenting UI alert view
    private func showAlert() -> Void {
        let alert = UIAlertController(title: "Welcome", message: "Welcome to Devnet, \(User.userName!) with email \(User.userEmail!)", preferredStyle: UIAlertControllerStyle.alert)
        let Ok = UIAlertAction(title: "Ok", style: .destructive) { (alert: UIAlertAction!) in
            performUIUpdatesOnMain {
                self.presentNextView()
            }
        }
        alert.addAction(Ok)
        present(alert, animated: true, completion: nil)
    }
    
    // Presenting next view controller
    private func presentNextView() -> Void {
        let storyBoard = UIStoryboard(name: "ApplicationView", bundle: nil)
        let homeTabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(homeTabBarController, animated: true, completion: nil)
    }

    // APP LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // For Facebook login button
        facebookLoginButton.delegate = self

        // For Google signin button
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().delegate = self

        
        
    }


}

