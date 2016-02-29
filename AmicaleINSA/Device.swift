//
//  Device.swift
//  AmicaleINSA
//
//  Created by Arthur Papailhau on 29/02/16.
//  Copyright © 2016 Arthur Papailhau. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Device Structure
// https://gist.github.com/imkevinxu/2bb1197552b095ab25c8

struct Device {
    
    // MARK: - Singletons
    
    static var TheCurrentDevice: UIDevice {
        struct Singleton {
            static let device = UIDevice.currentDevice()
        }
        return Singleton.device
    }
    
    
    static var TheCurrentDeviceHeight: CGFloat {
        struct Singleton {
            static let height = UIScreen.mainScreen().bounds.size.height
        }
        return Singleton.height
    }
    
    // MARK: - Device Idiom Checks
    
    static var PHONE_OR_PAD: String {
        if isPhone() {
            return "iPhone"
        } else if isPad() {
            return "iPad"
        }
        return "Not iPhone nor iPad"
    }
    
    static var DEBUG_OR_RELEASE: String {
        #if DEBUG
            return "Debug"
        #else
            return "Release"
        #endif
    }
    
    static var SIMULATOR_OR_DEVICE: String {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return "Simulator"
        #else
            return "Device"
        #endif
    }
    
    static func isPhone() -> Bool {
        return TheCurrentDevice.userInterfaceIdiom == .Phone
    }
    
    static func isPad() -> Bool {
        return TheCurrentDevice.userInterfaceIdiom == .Pad
    }
    
    static func isDebug() -> Bool {
        return DEBUG_OR_RELEASE == "Debug"
    }
    
    static func isRelease() -> Bool {
        return DEBUG_OR_RELEASE == "Release"
    }
    
    static func isSimulator() -> Bool {
        return SIMULATOR_OR_DEVICE == "Simulator"
    }
    
    static func isDevice() -> Bool {
        return SIMULATOR_OR_DEVICE == "Device"
    }
    
    // MARK: - Device Version Checks
    
    enum Versions: Float {
        case Five = 5.0
        case Six = 6.0
        case Seven = 7.0
        case Eight = 8.0
        case Nine = 9.0
    }
    
    
    // MARK: - Device Size Checks
    
    enum Heights: CGFloat {
        case Inches_3_5 = 480
        case Inches_4 = 568
        case Inches_4_7 = 667
        case Inches_5_5 = 736
    }
    
    static func isSize(height: Heights) -> Bool {
        return TheCurrentDeviceHeight == height.rawValue
    }
    
    static func isSizeOrLarger(height: Heights) -> Bool {
        return TheCurrentDeviceHeight >= height.rawValue
    }
    
    static func isSizeOrSmaller(height: Heights) -> Bool {
        return TheCurrentDeviceHeight <= height.rawValue
    }
    
    static var CURRENT_SIZE: String {
        if IS_3_5_INCHES() {
            return "iPhone4"
        } else if IS_4_INCHES() {
            return "iPhone5"
        } else if IS_4_7_INCHES() {
            return "iPhone6"
        } else if IS_5_5_INCHES() {
            return "iPhone6+"
        }
        return "\(TheCurrentDeviceHeight) Points"
    }
    
    // MARK: Retina Check
    
    static func IS_RETINA() -> Bool {
        return UIScreen.mainScreen().respondsToSelector("scale")
    }
    
    // MARK: 3.5 Inch Checks
    
    static func IS_3_5_INCHES() -> Bool {
        return isPhone() && isSize(.Inches_3_5)
    }
    
    static func IS_3_5_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.Inches_3_5)
    }
    
    static func IS_3_5_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrSmaller(.Inches_3_5)
    }
    
    // MARK: 4 Inch Checks
    
    static func IS_4_INCHES() -> Bool {
        return isPhone() && isSize(.Inches_4)
    }
    
    static func IS_4_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.Inches_4)
    }
    
    static func IS_4_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrSmaller(.Inches_4)
    }
    
    // MARK: 4.7 Inch Checks
    
    static func IS_4_7_INCHES() -> Bool {
        return isPhone() && isSize(.Inches_4_7)
    }
    
    static func IS_4_7_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.Inches_4_7)
    }
    
    static func IS_4_7_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrLarger(.Inches_4_7)
    }
    
    // MARK: 5.5 Inch Checks
    
    static func IS_5_5_INCHES() -> Bool {
        return isPhone() && isSize(.Inches_5_5)
    }
    
    static func IS_5_5_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.Inches_5_5)
    }
    
    static func IS_5_5_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrLarger(.Inches_5_5)
    }
    
    // MARK: - International Checks
    
    static var CURRENT_REGION: String {
        return NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
    }
    
    static var CURRENT_LANGUAGE: String {
        return NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
    }
    
}
