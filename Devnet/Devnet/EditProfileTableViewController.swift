//
//  EditProfileTableViewController.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/24/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    @IBAction func profilePictureAction(_ sender: Any) {
        handleImportPicture()
    }
    
    func handleImportPicture() {
        //Create instance of UIAlertController with title and message
        let importController = UIAlertController()
        
        //Setup import from Photo Library Action
        let importFromPhotoLibraryAction = UIAlertAction(title: "Import from Photo Library", style: UIAlertActionStyle.default) {
            action in
            importController.dismiss(animated: true, completion: nil)
            self.pickAnImageFromMediaLibrary()
        }
        
        //Setup import from camera action
        let importFromCameraAction = UIAlertAction(title: "Take a Picture", style: UIAlertActionStyle.default) {
            action in
            importController.dismiss(animated: true, completion: nil)
            self.pickAnImageFromCamera()
        }
        
        importFromCameraAction.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Setup cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            action in
            importController.dismiss(animated: true, completion: nil)
        }
        
        //Tells importButton to add actions
        importController.addAction(importFromPhotoLibraryAction)
        importController.addAction(importFromCameraAction)
        importController.addAction(cancelAction)
        
        //Tells importButton to present importController when it is tapped
        self.present(importController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            setImageToImageView(image: image)
            print("image is edited")
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setImageToImageView(image: image)
            print("image is original")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func setImageToImageView(image: UIImage) -> Void {
        profilePictureButton.setBackgroundImage(image, for: .normal)
    }
    
    //Tells the delegate that the user cancelled the pick operation.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Setup UIImagePickerController
    func setupImagePickerController(sourceType: UIImagePickerControllerSourceType) -> Void {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //HELPERS//
    
    //Picking an image action from Media Library
    func pickAnImageFromMediaLibrary() {
        setupImagePickerController(sourceType: .photoLibrary)
    }
    
    //Picking an image action from Camera
    func pickAnImageFromCamera() {
        setupImagePickerController(sourceType: .camera)
    }
    
    func setupProfileView() {
        
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileView()

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