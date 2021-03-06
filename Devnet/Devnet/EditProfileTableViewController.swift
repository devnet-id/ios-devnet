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
    
    let loadingIndicatorView = LoadingIndicatorView(text: "Saving Changes")
    
    let dimOverlayBackgroundView = UIView(frame: UIScreen.main.bounds)
    
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
        
        if let profileImage = user?.profileImage {
            profileImageView.image = profileImage
        } else {
            profileImageView.image = #imageLiteral(resourceName: "profileImageDefault")
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
        Firebase.databaseRef.child("users").child(uid).child("user").child("profileImageURL").setValue(profileImageURL, withCompletionBlock: { (firebaseDatabaseError, firebaseDatabaseRef) in
            guard firebaseDatabaseError == nil else {
                completion(firebaseDatabaseError.debugDescription)
                return
            }
            print(firebaseDatabaseRef.description())
            completion(nil)
        })
    }
    
    func setProfileImageDataToCurrentUser() {
        Firebase.getUser(uid: (FIRAuth.auth()?.currentUser?.uid)!) { (dictionary, errorMessage) in
            if errorMessage == nil {
                let user = User(dictionary: dictionary!)
                Current.shared().user = user
            }
        }
    }
    
    
    private func setupDimOverlayBackgroundView() {
        dimOverlayBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.66)
        dimOverlayBackgroundView.addSubview(loadingIndicatorView)
        UIApplication.shared.keyWindow?.addSubview(dimOverlayBackgroundView)
    }
    
    private func savingActivityIndicatorView(animating: Bool) {
        
        if animating == true {
            
            loadingIndicatorView.show()
            setupDimOverlayBackgroundView()
            
            
        } else {
            loadingIndicatorView.hide()
            loadingIndicatorView.removeFromSuperview()
            dimOverlayBackgroundView.removeFromSuperview()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfileView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
