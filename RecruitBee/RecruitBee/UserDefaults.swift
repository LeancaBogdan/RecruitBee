//
//  UserDefaults.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 13/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import Foundation

extension UserDefaults {
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case userId
        case type
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func setUserId(value: String) {
        set(value, forKey: UserDefaultsKeys.userId.rawValue)
        synchronize()
    }
    
    func getUserId() -> String {
        return string(forKey: UserDefaultsKeys.userId.rawValue)!
    }
    
    func getUserType() -> String {
        return string(forKey: UserDefaultsKeys.type.rawValue)!
    }
    
    func setUserType(value: String) {
        set(value, forKey: UserDefaultsKeys.type.rawValue)
        synchronize()
    }
}
