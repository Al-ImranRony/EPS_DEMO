//
//  ShopViewsConfig.swift
//  EPS_Demo
//
//  Created by Bitmorpher 4 on 2/3/23.
//

import Foundation
import UIKit

class ShopViewsConfig: NSObject {
    
    static let shared = ShopViewsConfig()
    var shopName: String?
    
    class func getConfirmedButtonColor() -> UIColor {
        return UIColor(red: 57/255, green: 119/255, blue: 42/255, alpha: 1)
    }
    
    class func getpartialCButtonColor() -> UIColor {
        return UIColor(red: 222/255, green: 168/255, blue: 60/255, alpha: 1)
    }
    
    class func getDelivredButtonColor() -> UIColor {
        return UIColor(red: 83/255, green: 42/255, blue: 27/255, alpha: 1)
    }
    
    class func getButtonBorderWidth() -> CGFloat {
        return 0.5
    }
    
    class func getButtonCornerRadius() -> CGFloat {
        return 18.0
    }
    
}
