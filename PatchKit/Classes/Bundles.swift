//
//  Bundles.swift
//  abseil
//
//  Created by Omar Rasheed on 5/21/20.
//

import Foundation

final class PatchKitImages {
    static let resourceBundle: Bundle = {
        let myBundle = Bundle(for: PatchKitImages.self)

        guard let resourceBundleURL = myBundle.url(
            forResource: "PatchKitImages", withExtension: "bundle")
            else { fatalError("PatchKitImages.bundle not found!") }

        guard let resourceBundle = Bundle(url: resourceBundleURL)
            else { fatalError("Cannot access PatchKitImages.bundle!") }

        return resourceBundle
    }()
}

final class PatchKitFonts {
    static let resourceBundle: Bundle = {
        let myBundle = Bundle(for: PatchKitFonts.self)

        guard let resourceBundleURL = myBundle.url(
            forResource: "PatchKitFonts", withExtension: "bundle")
            else { fatalError("PatchKitFonts.bundle not found!") }

        guard let resourceBundle = Bundle(url: resourceBundleURL)
            else { fatalError("Cannot access PatchKitFonts.bundle!") }

        return resourceBundle
    }()
}
