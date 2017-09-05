//
//  Protocol.swift
//  RxSwiftDemo
//
//  Created by yejiajun on 2017/9/4.
//  Copyright © 2017年 yejiajun. All rights reserved.
//

import Foundation

// MARK: - Enum
enum LoginResult {
    case invalidatedUsername
    case invalidatedPassword
    case success
    case failure
}

// MARK: - Protocol
protocol ValidatedModelType {
    func validatedUsername(_ username: String) -> String
    func validatedPassword(_ password: String) -> String
    func combine(_ username: String, _ password: String) -> String
    func login(_ username: String, _ password: String) -> LoginResult
}
