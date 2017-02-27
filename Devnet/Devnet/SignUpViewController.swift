//
//  SignUpViewController.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/23/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

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
        handleSignUp()
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
    
    
    func handleSignUp() {
        beginLoading()
        isTextFieldsEmpty { (success, dictionary, errorTextFields) in
            if success == true {
                self.getUserFromTextField(dictionary, completionForSignUp: { (email, password, userToPost, errorMessage) in
                    if errorMessage == nil {
                        
                        self.signUp(email: email, password: password, userToPost: userToPost, completion: { (error) in
                            if error == nil {
                                self.endLoadingWithoutAlert()
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                self.endLoading(error: error!)
                            }
                        })
                    } else {
                        self.endLoading(error: errorMessage!)
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
    
    func getUserFromTextField(_ dictionary: [String: String], completionForSignUp: (_ email: String, _ password: String, _ userToPost: [String: AnyObject], _ errorMessage: String?) -> Void) {
        if passwordTextField.text == repeatPasswordTextField.text {
            
            let firstName = dictionary["firstName"]!
            let lastName = dictionary["lastName"]!
            
            let name = firstName + " " + lastName
            
            let userName = dictionary["userName"]!
            let email = dictionary["email"]!
            
            let password = dictionary["password"]!
            
            var userToPost = [String: AnyObject]()
            
            userToPost["name"] = name as AnyObject?
            userToPost["userName"] = userName as AnyObject?
            userToPost["email"] = email as AnyObject?
            
            completionForSignUp(email, password, userToPost, nil)
            
            
        } else {
            endLoading(error: "Password doesn't match")
        }
        
        
    }
    
    func signUp(email: String, password: String, userToPost: [String: AnyObject], completion: @escaping (_ errorMessage: String?) -> Void) {
        Firebase.firebaseSignUp(email: email, password: password, dictionary: userToPost, completion: { (userID, errorMessage) in
            guard errorMessage == nil else {
                completion(errorMessage!)
                return
            }
            completion(nil)
        })
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
    
    func endLoadingWithoutAlert() {
        activityIndicator.stopAnimating()
        self.signUpButton.setTitle("Sign Up", for: .normal)
    }
    
    func showAlert(errorMessage: String) -> Void {
        let alert = UIAlertController(title: "Error Signing Up", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    // Tells delegate to dismiss keyboard when return is tapped
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configureTextFieldDelegate() {
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFieldDelegate()

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
