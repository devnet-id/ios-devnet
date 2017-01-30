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
        reference = FIRDatabase.database().reference()
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeTableViewController = segue.destination as! HomeTableViewController
        if segue.identifier == "Save" {
            if let note = note {
                // 1
                note.title = noteTitleTextField.text ?? ""
                note.content = noteContentTextView.text ?? ""
                // 2
                listNotesTableViewController.tableView.reloadData()
            } else {
                // 3
                let newNote = Note()
                newNote.title = noteTitleTextField.text ?? ""
                newNote.content = noteContentTextView.text ?? ""
                newNote.modificationTime = Date()
                listNotesTableViewController.notes.append(newNote)
            }
        }
    }
    */
    
}
