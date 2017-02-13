//
//  HomeTableViewController.swift
//  devnet
//
//  Created by Zulwiyoza Putra on 1/23/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var posts: [Post] = []
    
    @IBAction func newPostButton(_ sender: Any) {
        presentNewPost()
    }
    
    // Presenting sign up view controller
    private func presentNewPost() -> Void {
        let storyBoard = UIStoryboard(name: "NewPost", bundle: nil)
        let newPostNavigationController = storyBoard.instantiateViewController(withIdentifier: "NewPostNavigationController") as! UINavigationController
        self.present(newPostNavigationController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        posts = appDelegate.posts
        
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }

    }
    

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell

        // Configure the cell...
        
        let post = posts[indexPath.row]
        
        cell.content.text = post.postContent
        cell.modificationDate.text = post.postModificationDate?.dateToStringConverterHour()

        return cell
    }
    
    @IBAction func unwindToHomeTableViewController(_ segue: UIStoryboardSegue) {
        
        tableView.reloadData()
        
        
    }

}
