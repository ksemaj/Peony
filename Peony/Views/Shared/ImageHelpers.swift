//
//  ImageHelpers.swift
//  Peony
//
//  View-layer helpers for image handling
//  Keeps models platform-independent by removing UIKit dependencies
//

import SwiftUI

/// Extension to convert Data to UIImage in views
extension Data {
    /// Convert image data to UIImage for display in views
    /// - Returns: UIImage if data is valid image, nil otherwise
    var asUIImage: UIImage? {
        UIImage(data: self)
    }
}

/// Extension to convert UIImage to Data for storage
extension UIImage {
    /// Convert UIImage to JPEG data for model storage
    /// - Parameter compressionQuality: Quality level (0.0 to 1.0), defaults to 0.8
    /// - Returns: Compressed JPEG data
    func asJPEGData(compressionQuality: CGFloat = 0.8) -> Data? {
        self.jpegData(compressionQuality: compressionQuality)
    }
}

