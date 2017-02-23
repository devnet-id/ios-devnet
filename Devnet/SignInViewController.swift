//
//  SignInViewController.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/23/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signUpAction(_ sender: Any) {
        
        let signUpView = setupSignUpView()
        self.navigationController?.pushViewController(signUpView, animated: true)

        
    }
    
    @IBAction func signInAction(_ sender: Any) {
        
        beginLoading()
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            Firebase.firebaseSignIn(email: emailTextField.text!, password: passwordTextField.text!, completion: { (success, userID, errorMessage) in
                
                guard errorMessage == nil else {
                    self.endLoading(error: errorMessage!)
                    return
                }
                
                Firebase.shared().uid = userID!
                self.dismiss(animated: true, completion: nil)
                
            })
        }
        
        
    }
    
    func hideNavigationBar() {
        let blank = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(blank, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = blank
    }
    
    func setupSignUpView() -> UIViewController {
        let signUpStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpView = signUpStoryboard.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController
        return signUpView
    }
    
    func beginLoading() {
        activityIndicator.startAnimating()
        self.signInButton.setTitle("Signing In...", for: .normal)
    }
    
    func endLoading(error: String) {
        
        activityIndicator.stopAnimating()
        self.signInButton.setTitle("Sign In", for: .normal)
        showAlert(errorMessage: error)
    }
    
    private func showAlert(errorMessage: String) -> Void {
        let alert = UIAlertController(title: "Error Signing Up", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
