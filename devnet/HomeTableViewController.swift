//
//  HomeTableViewController.swift
//  devnet
//
//  Created by Zulwiyoza Putra on 1/23/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var posts: [Post]!
    
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        
        let post = posts[indexPath.row]
        
        cell.detailTextLabel?.text = "detail view"
        
        cell.textLabel?.text = post.postContent

        return cell
    }

}
