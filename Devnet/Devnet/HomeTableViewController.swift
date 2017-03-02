//
//  HomeTableViewController.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 3/2/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit
import Firebase

class HomeTableViewController: UITableViewController {
    
    var posts: [Post] = []
    
    @IBAction func newPostAction(_ sender: Any) {
        let newPostStoryboard = UIStoryboard(name: "NewPost", bundle: nil)
        let newPostView = newPostStoryboard.instantiateViewController(withIdentifier: "newPost") as! UINavigationController
        self.present(newPostView, animated: true, completion: nil)
    }
    
    func observePosts() {
        Firebase.getPost(uid: (FIRAuth.auth()?.currentUser?.uid)!) { (posts) in
            if posts != nil {
                self.posts = posts!
                print(self.posts)
                self.tableView.reloadData()
            } else {
                print("posts is nil")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        observePosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postListCell", for: indexPath) as! PostsListTableViewCell

        // Configure the cell...
        
        let post = posts[indexPath.row]
        
        print(post)

        cell.nameLabel.text = post.user?.name
        cell.contentLabel.text = post.content
        cell.timeStampLabel.text = post.timeStamp
        cell.profileImageView.image = #imageLiteral(resourceName: "profileImageDefault")
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
