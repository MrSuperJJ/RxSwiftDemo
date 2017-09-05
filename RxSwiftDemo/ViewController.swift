//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by yejiajun on 2017/7/13.
//  Copyright © 2017年 yejiajun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    // 在MVC中，ViewController担任View和Controller双重角色
    // 在MVVM中，ViewController只担任View的角色
    @IBOutlet weak var usernameTextFiled: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        mvcFunc()
        mvvmFunc()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: Alert
extension ViewController {
    
    func showAlertController(result: LoginResult) {
        let alertController = UIAlertController(title: "提示", message: result.description, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: MVC
// {
extension ViewController: UITextFieldDelegate {
    
    enum TextFieldTag: NSInteger {
        case username
        case password
    }
    
    func mvcFunc() {
        usernameTextFiled.tag = TextFieldTag.username.rawValue
        passwordTextField.tag = TextFieldTag.password.rawValue
        usernameTextFiled.delegate = self
        passwordTextField.delegate = self
        loginButton.addTarget(self, action: #selector(loginButtonAction(sender:)), for: .touchUpInside)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text
        var substring: String?
        if (range.length == 1 && string == "") {
            if let endIndex = text?.endIndex, let index = text?.index(endIndex, offsetBy: -1) {
                substring = text?.substring(to: index);
            }
        } else {
            substring = text?.appending(string)
        }
        if let currentText = substring {
            switch textField.tag {
            case TextFieldTag.username.rawValue:
                if let text = passwordTextField.text {
                    resultLabel.text = ValidatedModel.sharedInstance.combine(ValidatedModel.sharedInstance.validatedUsername(currentText), text)
                }
            case TextFieldTag.password.rawValue:
                if let text = usernameTextFiled.text {
                    resultLabel.text = ValidatedModel.sharedInstance.combine(text, ValidatedModel.sharedInstance.validatedPassword(currentText))
                }
            default:
                break
            }
        }
        return true
    }
    
    @objc func loginButtonAction(sender: UIButton) {
        if let username = usernameTextFiled.text, let password = passwordTextField.text {
            let result = ValidatedModel.sharedInstance.login(username, password)
            self.showAlertController(result: result)
        }
    }
}
// }

// MARK: MVVM 
// {
extension ViewController {
    
    func mvvmFunc() {
        let viewModel = ViewModel(username: usernameTextFiled.rx.text.orEmpty.asDriver(), password: passwordTextField.rx.text.orEmpty.asDriver(), loginTap: loginButton.rx.tap.asDriver(), model: ValidatedModel.sharedInstance)
        viewModel.validatedLabel.drive(resultLabel.rx.combinedResult).disposed(by: disposeBag)
        viewModel.loginResult.drive(onNext: { [unowned self] (result) in
            self.showAlertController(result: result)
        }).disposed(by: disposeBag)
    }
}

let disposeBag = DisposeBag()

private extension Reactive where Base: UILabel {
    var combinedResult: UIBindingObserver<Base, String> {
        return UIBindingObserver(UIElement: self.base, binding: { (label, string) in
            label.text = string
        })
    }
}
// }




