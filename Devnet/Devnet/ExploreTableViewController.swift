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
    
    var follower = [User]()
    
    func fetchUser(completion: @escaping (_ user: [User]?) -> Void) {
        
        var fetchedUsers = [User]()
        
        Firebase.databaseRef.child("users").observeSingleEvent(of: .childAdded, with: { (snapshot) in
            let userID = snapshot.key
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let userDictionary = dictionary["user"] as! [String: AnyObject]
                
                let userToAppend = User(dictionary: userDictionary)
                userToAppend.userID = userID
                
                if userToAppend.userID != FIRAuth.auth()?.currentUser?.uid {
                    fetchedUsers.append(userToAppend)
                    
                    
                    completion(fetchedUsers)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
            
        })
    }
    
    func getFollowing(uid: String, completion: @escaping (_ usersID: [String]) -> Void) {
        
        var usersID = [String]()
        
        Firebase.databaseRef.child("users").child(uid).child("following").observe(.childAdded, with: { (snapshot) in

            usersID.append(snapshot.key)
            completion(usersID)
        })
    }
    
    @IBAction func handleFollow(sender: UIButton) {
        
        let index = sender.tag
        
        let user = users[index]
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        for followingUser in following {
            if user.userID == followingUser.userID {
                Firebase.removeFollow(uid: uid!, uidToUnfollow: user.userID!, completion: {
                    self.tableView.reloadData()
                })
            } else {
                var dictionary = [String: AnyObject]()
                let date = NSDate()
                let timeStamp = date.description
                dictionary["timeStamp"] = timeStamp as AnyObject?
                
                
                Firebase.postFollow(uid: uid!, uidToFollow: user.userID!, dictionary: dictionary) {
                    self.tableView.reloadData()
                }

            }
        }
        
        
        
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

            self.getFollowing(uid: (FIRAuth.auth()?.currentUser?.uid)!, completion: { (usersID) in
                print("GETTING USERSID", usersID)
                for userID in usersID {
                    Firebase.getUser(uid: userID, { (dictionary, error) in
                        if error == nil {
                            let user = User(dictionary: dictionary!)
                            user.userID = userID
                            self.following.append(user)
                            self.tableView.reloadData()

                        }
                    })
                }
            })
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
        
        print(following)
        
        for followingUser in following {
            print(followingUser.description)
            
            let userIDInCell = user.userID
            let followingUserID = followingUser.userID
            print("USER ID IN CELL IS \(userIDInCell) AND FOLLOWING USER ID IS \(followingUserID)")
            if user.userID == followingUser.userID {
                cell.followButton.setTitle("Following", for: .normal)
            } else {
                cell.followButton.setTitle("Follow", for: .normal)
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
