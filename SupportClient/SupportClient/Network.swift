//
//  Network.swift
//  SupportClient
//
//  Created by Omar Rasheed on 5/9/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import Firebase
import FirebaseFirestore
import Foundation

class Network {
    
    static let shared = Network()
    
    private let commonPath = "Patch/data"
    static private let db = Firestore.firestore()

    func addFeedback(images: [UIImage], message: String, tags: [String], type: FeedbackType, completion: ((Feedback) -> Void)?) {
        ImageUploader(images: images).startUploading { urls in
            let jsonEncoder = JSONEncoder()
            jsonEncoder.keyEncodingStrategy = .convertToSnakeCase

            var model: Feedback
            if type == .customerService {
                model = TwoWayFeedback(imageUrls: urls, message: message, tags: tags, type: type)
            } else {
                model = OneWayFeedback(imageUrls: urls, message: message, tags: tags, type: type)
            }

            if let data = try? jsonEncoder.encode(model),
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                Network.db.collection("\(self.commonPath)/Feedback").document().setData(json) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        completion?(model)
                    }
                }
            }
        }
    }
    
    func getFeedback(completion: @escaping (([Feedback]) -> Void)) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        Network.db.collection("\(commonPath)/Feedback").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let feedback = querySnapshot?.documents.compactMap { document -> Feedback? in
                    let model = document.data()["has_read"] != nil ? TwoWayFeedback.self : OneWayFeedback.self
                    if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []), let feedback = try? jsonDecoder.decode(model, from: data) {
                        return feedback
                    }
                    return nil
                }
                if let feedback = feedback {
                    completion(feedback)
                }
            }
        }
    }
    
    func getTags(completion: @escaping (([String]) -> Void)) {
        Network.db.collection("Patch").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let data = querySnapshot?.documents.compactMap { $0.documentID == "data" ? $0.data()["tags"] : nil }
                if let data = data, let tags = data[0] as? [String] {
                    completion(tags)
                }
            }
        }
    }
    
}
