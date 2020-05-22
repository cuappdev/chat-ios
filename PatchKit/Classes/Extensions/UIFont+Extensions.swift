//
//  UIFont.swift
//  SupportClient
//
//  Created by Cameron Russell on 2/16/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

enum FontWeight: String {
    case medium = "Medium"
    case regular = "Regular"
}

enum RegisterFontError: Error {
    case invalidFontFile
    case fontPathNotFound
    case initFontError
    case registerFailed
}

extension UIFont {
    /// MAKE SURE TO REGISTER FONTS BELOW BEFORE USING
    
    static let _13RobotoMedium = roboto(size: 13, weight: .medium)
    static let _17RobotoMedium = roboto(size: 17, weight: .medium)
    static let _21RobotoMedium = roboto(size: 21, weight: .medium)
    
    static let _13RobotoRegular = roboto(size: 13, weight: .regular)
    static let _14RobotoRegular = roboto(size: 14, weight: .regular)
    static let _17RobotoRegular = roboto(size: 17, weight: .regular)
    static let _18RobotoRegular = roboto(size: 18, weight: .regular)
    static let _21RobotoRegular = roboto(size: 21, weight: .regular)
    
    private static func roboto(size: CGFloat, weight: FontWeight) -> UIFont {
        _ = UIFont.registerFonts
        if let font = UIFont(name: "Roboto-\(weight)", size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    private static var registerFonts: () = {
        do {
            try UIFont.register(fileNameString: "Roboto-Medium.ttf")
            try UIFont.register(fileNameString: "Roboto-Regular.ttf")
            // Add more fonts here as needed
        } catch {
            print("[PatchKit] Font Registration Failed")
        }
    }()
    
    private static func register(fileNameString: String) throws {
        guard let resourceBundleURL = PatchKitFonts.resourceBundle.path(forResource: fileNameString, ofType: nil) else {
            throw RegisterFontError.fontPathNotFound
        }
        guard let fontData = NSData(contentsOfFile: resourceBundleURL), let dataProvider = CGDataProvider.init(data: fontData) else {
            throw RegisterFontError.invalidFontFile
        }
        guard let fontRef = CGFont.init(dataProvider) else {
            throw RegisterFontError.initFontError
        }
        var errorRef: Unmanaged<CFError>? = nil
        guard CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) else   {
            throw RegisterFontError.registerFailed
        }
    }
}

