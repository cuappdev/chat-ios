//
//  ImageUploader.swift
//  SupportClient
//
//  Created by Omar Rasheed on 5/10/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import FirebaseStorage

/// Escaping field is an array of urls
typealias FileCompletion = ([String]) -> Void

class ImageUploader {
    
    private var onFileCompletion: FileCompletion?
    private var images: [UIImage] = []
    private let storage = Storage.storage()
    private var urls: [String] = []
    
    init(images: [UIImage]) {
        self.images = images
    }
    
    /// Recursively upload all images and run completion after last image is uploaded
    func startUploading(completion: @escaping FileCompletion) {
         if images.count == 0 {
            completion(urls)
            return
         }

         onFileCompletion = completion
         uploadImage(forIndex: 0)
    }

    func uploadImage(forIndex index:Int) {
        if index < images.count {
            /// Perform uploading
            let data = images[index].pngData()!
            let storageRef = storage.reference()
            let imageRef = storageRef.child("\(UUID().uuidString).png")
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else { return }
                    self.urls.append(downloadURL.absoluteString)
                    self.uploadImage(forIndex: index + 1)
                }
            }
            return
        }

        onFileCompletion?(urls)
    }
}
