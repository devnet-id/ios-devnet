//
//  NewPostViewController.swift
//  devnet
//
//  Created by Zulwiyoza Putra on 1/23/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit
import Foundation

class NewPostViewController: UIViewController {
    
    @IBOutlet weak var newPostTextView: UITextView!
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let post = Post(postTitle: nil, postContent: newPostTextView.text, postResponse: nil)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.posts.append(post)
        
        print(appDelegate.posts)
        let homeTableViewController = HomeTableViewController()
        homeTableViewController.tableView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
