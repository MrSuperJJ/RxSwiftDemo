//
//  ValidatedModel.swift
//  RxSwiftDemo
//
//  Created by yejiajun on 2017/9/4.
//  Copyright © 2017年 yejiajun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// Model
struct ValidatedModel:ValidatedModelType {
    
    static let sharedInstance = ValidatedModel()
    
    func validatedUsername(_ username: String) -> String {
        return username.uppercased()
    }
    
    func validatedPassword(_ password: String) -> String {
        return password.lowercased()
    }
    
    func combine(_ username: String, _ password: String) -> String {
        return username + password
    }
    
    func login(_ username: String, _ password: String) -> LoginResult {
        guard username.characters.count > 3 else { return .invalidatedUsername }
        guard password.characters.count > 3 else { return .invalidatedPassword }
        return (8...10).contains(username.characters.count + password.characters.count) ? .success : .failure
    }
}

extension LoginResult {
    
    var description: String {
        switch self {
        case .invalidatedUsername:
            return "无效的用户名"
        case .invalidatedPassword:
            return "无效的密码"
        case .success:
            return "登录成功"
        case .failure:
            return "登录失败"
        }
    }
}
