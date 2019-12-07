//
//  ViewController.swift
//  Tastebuds
//
//  Created by iForsan on 12/6/19.
//  Copyright © 2019 iForsan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

var user = UserDefaults.standard
var currentUser = "forsan"

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var usernameField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    @IBOutlet weak var rememberMe: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetButton: UIButton!
    
    
    @IBAction func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            loginButton.setTitle("Login", for: .normal)
        } else {
            loginButton.setTitle("Signup", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        containerView.layer.borderColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0).cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true

        fieldStyle(field: usernameField)
        fieldStyle(field: passwordField)
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        loginButton.layer.cornerRadius = 15
        
        forgetButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let username2 = user.object(forKey: "username") as? String {
            usernameField.text = username2
            passwordField.text = user.object(forKey: "password") as? String
        }
        
        rememberMe.isOn = user.bool(forKey: "rememberMe")
    }
    
    func fieldStyle(field: SkyFloatingLabelTextField) {
        
        let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
        let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)

        field.tintColor = overcastBlueColor // the color of the blinking cursor
        field.textColor = darkGreyColor
        field.lineColor = lightGreyColor
        field.selectedTitleColor = overcastBlueColor
        field.selectedLineColor = overcastBlueColor

        field.lineHeight = 1.0 // bottom line height in points
        field.selectedLineHeight = 2.0
    }

    @IBAction func LoginAction(_ sender: Any) {
        
        if usernameField.text?.count == 0 {
            usernameField.errorMessage = "Please enter the username"
            return
        } else {
            // The error message will only disappear when we reset it to nil or empty string
            usernameField.errorMessage = ""
        }
        
        if passwordField.text?.count == 0 {
            passwordField.errorMessage = "Please enter the password"
            return
        } else {
            // The error message will only disappear when we reset it to nil or empty string
            passwordField.errorMessage = ""
        }
        
        if segmentView.selectedSegmentIndex == 0 {

            // login
            if db.selectUser(usernameValue: usernameField.text!) != nil {
                if db.validateUser(usernameValue: usernameField.text!, passwordValue: passwordField.text!) {
                print("login")
                currentUser = usernameField.text!
                startAnimating()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        stopAnimating(nil)
                        
                        if self.rememberMe.isOn {
                            user.set(self.usernameField.text!, forKey: "username")
                            user.set(self.passwordField.text!, forKey: "password")
                        } else {
                            user.removeObject(forKey: "username")
                            user.removeObject(forKey: "password")
                            self.usernameField.text = nil
                            self.passwordField.text = nil
                        }
                        

                        user.set(self.rememberMe.isOn, forKey: "rememberMe")


                        
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TasteMakeViewController") as? TasteMakeViewController
                        self.navigationController?.pushViewController(controller!, animated: true)
                    }
                    
                } else {
                    passwordField.errorMessage = "The username is not correct"
                }
            } else {
                usernameField.errorMessage = "The username is not exist"
                return
            }

        } else {
            
            // signup
            if db.selectUser(usernameValue: usernameField.text!) == nil {
                db.insertUser(usernameValue: usernameField.text!, passwordValue: passwordField.text!)
                
                startAnimating()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        stopAnimating(nil)
                        
                        if self.rememberMe.isOn {
                            user.set(self.usernameField.text!, forKey: "username")
                            user.set(self.passwordField.text!, forKey: "password")
                        } else {
                            user.removeObject(forKey: "username")
                            user.removeObject(forKey: "password")
                            self.usernameField.text = nil
                            self.passwordField.text = nil
                        }
                        user.set(self.rememberMe.isOn, forKey: "rememberMe")



                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TasteMakeViewController") as? TasteMakeViewController
                        self.navigationController?.pushViewController(controller!, animated: true)
                    }
            } else {
                usernameField.errorMessage = "The username already exist"
                return
            }            
        }
        
    }
    
    @IBAction func forgetAction(_ sender: Any) {
    }
}

extension ViewController: UITextFieldDelegate {
    
    // This will notify us when something has changed on the textfield
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = usernameField {
                if text.count == 0 {
                    floatingLabelTextField.errorMessage = "Please enter the username"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            } else if let floatingLabelTextField = passwordField {
                if text.count == 0 {
                    floatingLabelTextField.errorMessage = "Please enter the password"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
}

