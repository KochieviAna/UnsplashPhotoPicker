//
//  Font+Extension.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI

extension Font {
    static func poppinsLight(size: CGFloat) -> Font {
        return Font.custom("Poppins-Light", size: size)
    }
    
    static func poppinsRegular(size: CGFloat) -> Font {
        return Font.custom("Poppins-Regular", size: size)
    }
    
    static func poppinsMedium(size: CGFloat) -> Font {
        return Font.custom("Poppins-Medium", size: size)
    }
}
