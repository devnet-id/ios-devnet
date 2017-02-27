//
//  EditProfileTableViewController.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/24/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController {
    
    var user = Current.shared().user
    
    @IBOutlet weak var profilePictureButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileBioLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    func configureProfileView() {
        
        actionForProfileImageView()
        
        if let name = user?.name {
            nameLabel.text = name
        }
        
        if let userName = user?.userName {
            usernameLabel.text = "@" + userName
        }
        
        if let gender = user?.gender {
            genderLabel.text = gender.rawValue
        }
        
        if let dateOfBirth = user?.dateOfBirth {
            let arrayOfDateOfBirth = dateOfBirth.components(separatedBy: "/")
            let month = arrayOfDateOfBirth[0]
            let date = arrayOfDateOfBirth[1]
            let year = arrayOfDateOfBirth[2]
            
            var monthName = String()
            
            switch month {
            case "01":
                monthName = "January"
            case "02":
                monthName = "February"
            case "03":
                monthName = "March"
            case "04":
                monthName = "April"
            case "05":
                monthName = "May"
            case "06":
                monthName = "June"
            case "07":
                monthName = "July"
            case "08":
                monthName = "August"
            case "09":
                monthName = "September"
            case "10":
                monthName = "October"
            case "11":
                monthName = "November"
            case "12":
                monthName = "December"
            default:
                monthName = "nil"
            }
            
            dateOfBirthLabel.text = monthName + " " + date + " ," + year
        } else {
            dateOfBirthLabel.text = "January 01, 1900"
        }
    }

    func actionForProfileImageView() {
        let actionSelector = #selector(handleImportImage)
        let gestureRecognier = UITapGestureRecognizer(target:
            self, action: actionSelector)
        profileImageView.addGestureRecognizer(gestureRecognier )
        profileImageView.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureProfileView()

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

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
