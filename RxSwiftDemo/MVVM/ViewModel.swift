//
//  ViewModel.swift
//  RxSwiftDemo
//
//  Created by yejiajun on 2017/9/4.
//  Copyright © 2017年 yejiajun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// Model
struct ViewModel {

    let validatedLabel: Driver<String>
    let loginResult: Driver<LoginResult>
    
    init(username: Driver<String>, password: Driver<String>, loginTap: Driver<Void>, model: ValidatedModelType) {
        validatedLabel = Driver.combineLatest(username, password, resultSelector: { model.combine(model.validatedUsername($0), model.validatedPassword($1)) })
        let usernameAndPassword = Driver.combineLatest(username, password) { ($0, $1) }
        loginResult = loginTap.withLatestFrom(usernameAndPassword).map({ (username, password) in
            model.login(username, password)
        })
    }
}
