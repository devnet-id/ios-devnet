//
//  SignInViewController.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/23/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signUpAction(_ sender: Any) {
        
        self.navigationController?.pushViewController(self.setupSignUpView(), animated: true)

        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

