//
//  ExploreTableViewController.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/24/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit
import Firebase

class ExploreTableViewController: UITableViewController {

    var users = [User]()
    
    var followedStatus: Bool = false
    
    var following = [User]()
    
    var followers = [User]()
    
    func fetchUser(completion: @escaping (_ user: [User]?) -> Void) {
        
        var fetchedUsers = [User]()
        
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            let userID = snapshot.key
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let userDictionary = dictionary["user"] as! [String: AnyObject]
                
                let userToAppend = User(dictionary: userDictionary)
                userToAppend.userID = userID
                fetchedUsers.append(userToAppend)
                
                completion(fetchedUsers)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        })
    }
    
    @IBAction func handleFollow(sender: UIButton) {
        
        let index = sender.tag
        
        let user = users[index]
        
        var dictionary = [String: AnyObject]()
        let date = NSDate()
        let timeStamp = date.description
        dictionary["timeStamp"] = timeStamp as AnyObject?
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        Firebase.postFollow(uid: uid!, uidToFollow: user.userID!, dictionary: dictionary)
        
        if let currentUserFollowingArray = Current.shared().user?.following {
            for followingUser in currentUserFollowingArray {
                if followingUser.userID != user.userID {
                    tableView.reloadData()
                }
            }
        } else {
            
        }
        
        print(sender.tag)
        
        
//        if followedStatus == false {
//            
//            
//            followButton.setTitle("Following", for: .normal)
//            followedStatus = true
//            
//        } else {
//            followButton.setTitle("Follow", for: .normal)
//            followedStatus = false
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchUser { (users) in
            self.users = users!
            let followingUsers = [User]()
                
            Current.shared().user?.following
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

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
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as! UserListTableViewCell
        
        let user = users[indexPath.row]
        
        cell.nameLabel.text = user.name!
        cell.usernameLabel.text = "@" + user.userName!
        
        if let profileImage = user.profileImage {
            cell.profileImageView.image = profileImage
        }
        
        if let currentUserFollowingArray = Current.shared().user?.following {
            for followingUser in currentUserFollowingArray {
                if user.userID == followingUser.userID {
                    cell.followButton.setTitle("Following", for: .normal)
                } else {
                    cell.followButton.setTitle("Follow", for: .normal)
                }
            }
        }
        
        cell.followButton.tag = indexPath.row
        
        cell.followButton.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        
        return cell
        
        // Configure the cell...

        
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
