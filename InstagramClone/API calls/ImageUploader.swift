//
//  ImageUploader.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/5/21.
//

import UIKit
import FirebaseStorage

struct ImageUploader {
    
    //the completion block will return a string, which is the url for the image
    static func uploadImage(image: UIImage, completionBlock: @escaping(String) -> Void) {
        
        //let's make the compressionQuality little smaller so that it's faster when we download the file image from the internet
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            print("DEBUG: error setting imageData")
            return
        }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        //let's put the image into the database, Storage
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            guard error == nil else {
                print("DEBUG: error putData - \(String(describing: error?.localizedDescription))")
                return
            }
            
            //let download the image that we just upload to storage
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completionBlock(imageUrl) //whenever this uploadImage func gets called (with an image already uploaded), we can use the downloaded url as imageUrl
                print("DEBUG: profileImageUrl: \(imageUrl)")
            }
            
        } //done putting image into storage
        
        
    }//done with this func
    
    
    
    
    
}
