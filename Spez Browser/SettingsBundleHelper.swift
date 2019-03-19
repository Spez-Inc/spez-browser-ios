//
//  SettingsBundleHelper.swift
//  Spez Browser
//
//  Created by Konuk Kullanıcı on 17.03.2019.
//  Copyright © 2019 Spez Inc. All rights reserved.
//

import Foundation
class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let Reset = "dark-mode"
        static let AppVersionKey = "ver"
    }
    
    class func checkAndExecuteSettings() {
    }
    
    class func setVersionAndBuildNumber() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        UserDefaults.standard.set(version, forKey: "ver")
    }
}
