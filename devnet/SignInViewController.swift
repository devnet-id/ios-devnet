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
import OAuthSwift

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    // VARIABLES
    var appDelegate: AppDelegate!
    
    var oAuthSwift: OAuthSwift?
    
    // OUTLETS
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // Google Sign In Button Instance
    @IBOutlet weak var googleSgnInButton: GIDSignInButton!
    
    @IBAction func connectWithFacebook(_ sender: Any) {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            if error != nil {
                print("Custom FB Login Failed:", error!)
            } else {
                self.facebookSignInRequest()
            }
            
        }
        
    }
        
    @IBAction func signInButton(_ sender: Any) {
        
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
        }
        
        signIn()
        
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        presentSignUpView()
        
    }
    
    // SIGN IN with email
    private func signIn() -> Void {
        if let email = email.text, let password = password.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print("There was an error occured \(error.debugDescription)")
                    
                    performUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                    }
                    
                } else {
                    print("Logged in")
                    print(user!)
                    
                    performUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                        self.presentNextView()
                    }
                }
            })
        }
    }
    
    // LOGIN AND LOGOUT SETUP FOR FACEBOOK
    
    // Handling for if login complete
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
        }
        
        // Was there any error occurs?
        guard (error == nil) else {
            print("Could not sign in to Facebook with error: ", error)
            return
        }
        
        facebookSignInRequest()
        
        print("Successfully logged in from Facebook")
        
        performUIUpdatesOnMain {
            self.activityIndicator.stopAnimating()
        }

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
                print("There was an error occurs: ", error!)
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
            
            if User.userID != nil {
                self.presentNextView()
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
        
        print(accessToken)
        
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
            
            
            
        })
        
        if User.userID != nil {
            self.presentNextView()
        }

        
    }
    
    
    // LOGIN AND LOG OUT SETUP FOR GITHUB SIGN IN
    
    // For Github Sign In
    

    
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
    
    // Presenting sign up view controller
    private func presentSignUpView() -> Void {
        let storyBoard = UIStoryboard(name: "SignUpView", bundle: nil)
        let homeTabBarController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(homeTabBarController, animated: true, completion: nil)
    }

    // APP LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        // For Google signin button
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().delegate = self

        
        
    }


}

