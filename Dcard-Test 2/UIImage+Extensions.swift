//
//  UIImage+Extensions.swift
//  Dcard-Test 2
//
//  Created by Ryan Chang on 2021/6/10.
//

import Foundation
import UIKit

extension UIImage {
    static func image(url: URL, handel: @escaping (UIImage?) -> ()) {
        guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
            handel(nil)
            return
        }
        handel(image)
    }
    
    func scaled(scale: CGFloat) -> UIImage? {
        let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
