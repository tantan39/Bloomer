//
//  UIImageExtension.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import UIKit
//import SwiftyGif

extension UIImage {
    
    public class func imageFromCodeBase(name: String) -> UIImage? {
        let codeBaseBundle = Bundle(for: BaseViewController.self)
        return UIImage(named: name, in: codeBaseBundle, compatibleWith: nil)
    }

    // Use this function to get image from main bundle, if image is null then will get from framework's bundle
    public class func initWith(named name: String, bundle: Bundle) -> UIImage? {
        guard let image  = UIImage(named: name, in: .main, compatibleWith: nil) else {
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
        return image
    }
    
    public func tint(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    public func toBlackAndWhite() -> UIImage {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
        currentFilter!.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 3.0)
        processedImage.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    public var flippedHorizontally: UIImage {
        return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: .upMirrored)
    }
}
