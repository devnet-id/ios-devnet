//
//  EditProfileTableViewController.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/24/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit
import Firebase

class EditProfileTableViewController: UITableViewController {
    
    var user = Current.shared().user
    
    var isProfileEdited = false
    
    let loadingIndicatorView = LoadingIndicatorView(text: "Loading")
    
    let overlayView = UIView()
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileBioLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func saveAction(_ sender: Any) {
        
        savingActivityIndicatorView(animating: true)
        
        
        uploadImageToFirebaseStorage(image: profileImageView.image!, completionForUploadingImage: { (errorMessage) in
            if errorMessage == nil {
                self.savingActivityIndicatorView(animating: false)
                let _ = self.navigationController?.popViewController(animated: true)
            } else {
                print(errorMessage!)
            }
        })

        
    }
    func configureProfileView() {
        
        saveButton.isEnabled = false
        
        addActionForTappingProfileImageView()
        
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

    func addActionForTappingProfileImageView() {
        let actionSelector = #selector(handleImportImage)
        let gestureRecognier = UITapGestureRecognizer(target:
            self, action: actionSelector)
        profileImageView.addGestureRecognizer(gestureRecognier )
        profileImageView.isUserInteractionEnabled = true
    }
    
    func uploadImageToFirebaseStorage(image: UIImage, completionForUploadingImage: @escaping (_ errorMessage: String?) -> Void) {
        if let dataToUpload = UIImagePNGRepresentation(image) {
            let uid = FIRAuth.auth()?.currentUser?.uid
            let dataName = uid! + ".png"
            Firebase.storageRef.child(dataName).put(dataToUpload, metadata: nil, completion: { (firebaseStorageMetadata, firebaseStorageError) in
                if firebaseStorageError == nil {
                    print(firebaseStorageMetadata!)
                    if let profileImageURL = firebaseStorageMetadata?.downloadURL()?.absoluteString {
                        self.postProfileImageDownloadURLWithUID(uid: uid!, profileImageURL: profileImageURL, completion: { (errorMessage) in
                            completionForUploadingImage(errorMessage)
                        })
                    }
                } else {
                    completionForUploadingImage(firebaseStorageError.debugDescription)
                }
            })
        }
    }
    
    func postProfileImageDownloadURLWithUID(uid: String, profileImageURL: String, completion: @escaping (_ errorMessage: String?) -> Void) {
        Firebase.databaseRef.child("users").child(uid).child("profileImageURL").setValue(profileImageURL, withCompletionBlock: { (firebaseDatabaseError, firebaseDatabaseRef) in
            guard firebaseDatabaseError == nil else {
                completion(firebaseDatabaseError.debugDescription)
                return
            }
            print(firebaseDatabaseRef.description())
            completion(nil)
        })
    }
    
    private func savingActivityIndicatorView(animating: Bool) {
        
        if animating == true {
            loadingIndicatorView.show()
            
            overlayView.frame = (UIApplication.shared.keyWindow?.frame)!
            overlayView.center = (UIApplication.shared.keyWindow?.center)!
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            
            overlayView.addSubview(loadingIndicatorView)
            UIApplication.shared.keyWindow?.addSubview(overlayView)
//
//            // You only need to adjust this frame to move it anywhere you want
//            
//            containerView.frame = CGRect(x: view.frame.midX - 100, y: view.frame.midY - 30, width: 200, height: 60)
//            
//            
//            containerView.backgroundColor = UIColor.white
//            containerView.alpha = 1
//            containerView.layer.cornerRadius = 10
//            
//            //Here the spinnier is initialized
//            let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
//            activityView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
//            activityView.startAnimating()
//            
//            let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 140, height: 60))
//            textLabel.textColor = UIColor.gray
//            textLabel.text = "Saving Changes"
//            
//            containerView.addSubview(blurredBackgroundView)
//            containerView.addSubview(activityView)
//            containerView.addSubview(textLabel)
//            
//            overlayView.addSubview(containerView)
//            


        } else {
            overlayView.removeFromSuperview()
//            self.view.isUserInteractionEnabled = true
            
            loadingIndicatorView.hide()
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureProfileView()
        
//        overlayView.frame = window.frame
//        overlayView.center = window.center
//        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
//        overlayView.addSubview(loadingIndicatorView)
        self.view.addSubview(loadingIndicatorView)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileTableViewController = segue.destination as! ProfileTableViewController
        profileTableViewController.profileImage = profileImageView.image!
        profileTableViewController.tableView.reloadData()
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
