//
//  PatchKit.swift
//  SupportClient
//
//  Created by Cameron Russell on 5/17/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//
import FirebaseCore
import FirebaseFirestore

open class PatchKit {

    static var db: Firestore!

    /**
     Users must rename PatchKit dedicated plist to "GoogleService-PatchKit" or modify the below
     resource identifier to properly connect to database.
     */
    public static func configure() {
        let filePath = Bundle.main.path(forResource: "GoogleService-PatchKit", ofType: "plist")
        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!) else {
            fatalError("Could not properly local plist file")
        }
        FirebaseApp.configure(name: "PatchKit", options: fileopts)
        guard let app = FirebaseApp.app(name: "PatchKit") else {
            fatalError("Could not configure FirebaseApp")
        }
        db = Firestore.firestore(app: app)
    }

    public static func showFeedbackInbox() {
        // TODO: show feedback inbox
    }

    public static func showFeedbackForm() {
        showFeedbackInbox()
        // TODO: present feedback form
    }

}
