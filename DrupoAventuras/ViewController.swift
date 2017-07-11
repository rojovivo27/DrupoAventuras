//
//  ViewController.swift
//  DrupoAventuras
//
//  Created by Aldo Roldan Hernandez Rea on 20/03/17.
//  Copyright © 2017 Aldo Roldan Hernandez Rea. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = view.frame
        loginButton.delegate = self
        loginButton.readPermissions = ["email","public_profile"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Successfully logged in with facebook...")
        showEmailAddress()
    }
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with FB user: ", error ?? "")
                return
            }
            
            print("Successfully logged in with our user: ", user ?? "")
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start {
            (connection, result, error) in
            if error != nil {
                print("Failed to start graph request: ", error ?? "")
                return
            }
            
            print(result ?? "")
            
            let res = result as! [String: Any]
            let email = res["email"]
            
            let alert = UIAlertController(title: "Bienvenido", message: email as! String?, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "entrar", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }


}

