//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Archit Jain on 10/3/20.
//  Copyright © 2020 archit. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser.current()
        if user?["image"] != nil {
            let imageFile = user?["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            profileImageView.af.setImage(withURL: url)
        }
        
        nameLabel.text = PFUser.current()?.username
    }
    
    @IBAction func onTapProfileImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        profileImageView.image = scaledImage
        dismiss(animated: true, completion: nil)
        
        let user = PFUser.current()
        let imageData = profileImageView.image?.pngData()
        let file = PFFileObject(data: imageData!)
        user?["image"] = file
        user?.saveInBackground(block: { (success, error) in
            if success {
                print("Profile image updated")
            }
            else{
                print("Error updating profile image: \(String(describing: error))")
            }
        })
    }
}
