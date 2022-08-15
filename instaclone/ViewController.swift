//
//  ViewController.swift
//  instaclone
//
//  Created by Yigit Ozdamar on 13.08.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != ""{
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!){ (authResult, error) in
                if error != nil {
                    self.makeAlert(title: "Error!", alertMessage: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)

                }
                
              }
        }else{
            makeAlert(title: "Error", alertMessage: "Username/Password")
        }
        
    }
    
    @IBAction func singUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != ""{
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
                
                if error != nil {
                    self.makeAlert(title: "Error!", alertMessage: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            makeAlert(title: "Error", alertMessage: "Username/Password")
        }
        
        
    }
    
    func makeAlert(title:String,alertMessage:String){
        let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}

