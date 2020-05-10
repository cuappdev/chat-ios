//
//  ImageUploader.swift
//  SupportClient
//
//  Created by Omar Rasheed on 5/10/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import Firebase
import FirebaseFirestore

import Foundation

/// Escaping field is an array of urls
typealias FileCompletionBlock = ([String]) -> Void

class ImageUploader {
    
    var block: FileCompletionBlock?
    var images: [UIImage] = []
    let storage = Storage.storage()
    var urls: [String] = []
    
    init(images: [UIImage]) {
        self.images = images
    }
    
    /// Recursively upload all images and run completion after last image is uploaded
    func startUploading(completion: @escaping FileCompletionBlock) {
         if images.count == 0 {
            completion(urls)
            return
         }

         block = completion
         uploadImage(forIndex: 0)
    }

    func uploadImage(forIndex index:Int) {
         if index < images.count {
            /// Perform uploading
            let data = images[index].pngData()!
            let storageRef = storage.reference()
            let riversRef = storageRef.child("images/arrow\(index).png")
            riversRef.putData(data, metadata: nil) { (metadata, error) in
                riversRef.downloadURL { (url, error) in
                    guard let downloadURL = url else { return }
                    self.urls.append(downloadURL.absoluteString)
                    self.uploadImage(forIndex: index + 1)
                }
            }
            return
          }

          if block != nil {
             block!(urls)
          }
    }
    
}
