//
//  NewPostViewController.swift
//  devnet
//
//  Created by Zulwiyoza Putra on 1/23/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

class NewPostViewController: UIViewController {
    
    var reference: FIRDatabaseReference?
    var post: Post?
    
    @IBOutlet weak var newPostTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reference = FIRDatabase.database().reference()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeTableViewController = segue.destination as! HomeTableViewController
        if segue.identifier == "save" {
            if var post = post {
                
                post.postTitle = newPostTextView.text ?? ""
                homeTableViewController.tableView.reloadData()
            } else {
                // 3
                var newPost = Post()
                newPost.postTitle = newPostTextView.text ?? ""
                newPost.postModificationDate = Date()
                homeTableViewController.posts.append(newPost)
            }
        }
    }
    
}
