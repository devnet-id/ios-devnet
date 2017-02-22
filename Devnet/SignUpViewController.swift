//
//  SignUpViewController.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/23/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    var user = User()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpAction(_ sender: Any) {
        
        beginLoading()
        
        isTextFieldsEmpty { (success, dictionary, errorTextFields) in
            
            if success == true {
                
                self.handleSignUp(dictionary, completionForSignUp: { (errorMessage) in
                    
                    if errorMessage != nil {
                      self.endLoading(error: errorMessage!)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                })
                
            } else {
                
                if errorTextFields?.count == 1 {
                    for x in errorTextFields! {
                        self.endLoading(error: "Please fill your \(x)")
                    }
                } else {
                    self.endLoading(error: "Please fill the blank text fields")
                }
                
            }
            
        }
        
        
    }
    
    func isTextFieldsEmpty(completion: @escaping (_ success: Bool,_ dictionary: [String: String], _ errorTextFields: [String]?) -> Void) {
        
        var successTextFieldValue = [String: String]()
        var failedTextFieldValue = [String]()
        
        if firstNameTextField.text?.isEmpty ?? true {
            failedTextFieldValue.append("First Name")
        } else {
            successTextFieldValue["firstName"] = firstNameTextField.text
        }
        
        if lastNameTextField.text?.isEmpty ?? true {
            failedTextFieldValue.append("Last Name")
        } else {
            successTextFieldValue["lastName"] = lastNameTextField.text
        }
        
        if userNameTextField.text?.isEmpty ?? true {
            failedTextFieldValue.append("Username")
        } else {
            successTextFieldValue["userName"] = userNameTextField.text
        }
        
        if emailTextField.text?.isEmpty ?? true {
            failedTextFieldValue.append("Email")
        } else {
            successTextFieldValue["email"] = emailTextField.text
        }
        
        if passwordTextField.text?.isEmpty ?? true {
            failedTextFieldValue.append("Password")
        } else {
            successTextFieldValue["password"] = passwordTextField.text
        }
        
        if repeatPasswordTextField.text?.isEmpty ?? true {
            failedTextFieldValue.append("Repat Password")
        } else {
            successTextFieldValue["repatPassword"] = repeatPasswordTextField.text
        }
        
        if failedTextFieldValue.count == 0 {
            completion(true, successTextFieldValue, nil)
        } else {
            completion(false, successTextFieldValue, failedTextFieldValue)
        }
        
    }
    
    func handleSignUp(_ dictionary: [String: String], completionForSignUp: @escaping (_ errorMessage: String?) -> Void) {
        if passwordTextField.text == repeatPasswordTextField.text {
            
            let firstName = dictionary["firstName"]!
            let lastName = dictionary["lastName"]!
            
            let name = firstName + " " + lastName
            
            let userName = dictionary["userName"]!
            let email = dictionary["email"]!
            
            let password = dictionary["password"]!
            
            Firebase.firebaseSignUp(email: email, password: password, completion: { (success, userID, errorMessage) in
                
                guard errorMessage != nil else {
                    completionForSignUp(errorMessage)
                    return
                }
                
                Firebase.shared().uid = userID!
                
                var userToPost = [String: String]()
                
                userToPost["name"] = name
                userToPost["userName"] = userName
                userToPost["email"] = email
                
                Firebase.postUser(dictionary: userToPost as [String : AnyObject], { (success, errorString) in
                    
                    if errorMessage != nil {
                        
                        completionForSignUp(errorString)
                        
                    }
                    
                })
                
            })
            
            
            
        } else {
            endLoading(error: "Password doesn't match")
        }
        
        
    }
    
    func beginLoading() {
        activityIndicator.startAnimating()
        self.signUpButton.setTitle("Signing Up...", for: .normal)
    }
    
    func endLoading(error: String) {
        
        activityIndicator.stopAnimating()
        self.signUpButton.setTitle("Sign Up", for: .normal)
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
