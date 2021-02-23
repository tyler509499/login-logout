//
//  ViewController.swift
//  login-logout
//
//  Created by Galkov Nikita on 21.02.2021.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var networkManager = NetworkManager()
    
    var checkComplete: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTap(#selector(dismissKeyboard))
        loginLabel.text = "Login"
        passwordLabel.text = "Password"
        loginTextField.placeholder = "Enter your login"
        passwordTextField.placeholder = "Enter your password"
        signInButton.layer.cornerRadius = 6
        
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        checkEmptyFields()
        guard checkComplete == true else {
            return
        }
        networkManager.postLogin(login: loginTextField.text!, password: passwordTextField.text!) { response, error in
            if error != nil {
                self.oneButtonAlert(title: "Bad Request", message: "Try again later or check your Request function")
                return
            }
            if response != nil {
                if NetworkManager.token != nil {
                self.performSegue(withIdentifier: "goPayments", sender: nil)
            } else {
                self.oneButtonAlert(title: "Wrong login or password", message: "Try again")
                self.loginTextField.text = ""
                self.passwordTextField.text = ""
            }
        }
    }
}
}
extension SignInViewController {
    
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SignInViewController {
    func checkEmptyFields() {
        if loginTextField.text == "" || loginTextField.text == nil {
            checkComplete = false
            let alert = UIAlertController(title: "Empty Login Field", message: "Enter your login", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                                                self.loginTextField.becomeFirstResponder()
                                            }})
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        } else {
            checkComplete = true
            
        }
        if passwordTextField.text == "" || passwordTextField.text == nil{
            checkComplete = false
            let alert = UIAlertController(title: "Empty Password Field", message: "Enter your password", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                                                self.passwordTextField.becomeFirstResponder()
                                            }})
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        } else {
            checkComplete = true
        }
    }
}


