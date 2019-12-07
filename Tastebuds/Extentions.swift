//
//  Extentions.swift
//  App
//
//  Created by iForsan on 12/5/19.
//  Copyright © 2019 iForsan. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

extension NSDictionary {
    func toString() throws -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

extension String {
    
    var parseJSONString: AnyObject? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject] {
                    return jsonResult as AnyObject
                }
                return nil
            } catch {
                return nil
            }
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}

//extension UIViewController: NVActivityIndicatorViewable {
//    
//    @objc func buttonTapped() {
//        
//        
//        
//        
//        let size = CGSize(width: 50, height: 50)
//        let selectedIndicatorIndex = 14 //sender.tag
////        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
//        let indicatorType = NVActivityIndicatorType.allCases.filter { $0 != .blank }[selectedIndicatorIndex]
//        
//        startAnimating(size, message: "Loading...", type: indicatorType, fadeInAnimation: nil)
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//            NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
//            self.stopAnimating(nil)
//        }
//    }
//    
//}

func startAnimating(
    _ size: CGSize? = nil,
    message: String? = "Loading...",
    messageFont: UIFont? = nil,
    type: NVActivityIndicatorType? = .ballClipRotatePulse,
    color: UIColor? = nil,
    padding: CGFloat? = nil,
    displayTimeThreshold: Int? = nil,
    minimumDisplayTime: Int? = nil,
    backgroundColor: UIColor? = nil,
    textColor: UIColor? = nil,
    fadeInAnimation: FadeInAnimation? = NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION) {
    let activityData = ActivityData(size: size,
                                    message: message,
                                    messageFont: messageFont,
                                    type: type,
                                    color: color,
                                    padding: padding,
                                    displayTimeThreshold: displayTimeThreshold,
                                    minimumDisplayTime: minimumDisplayTime,
                                    backgroundColor: backgroundColor,
                                    textColor: textColor)

    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, fadeInAnimation)
}

func stopAnimating(_ fadeOutAnimation: FadeOutAnimation? = NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION) {
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(fadeOutAnimation)
}
