//
//  LoginViewController.swift
//  TrophyProject
//
//  Created by ldong on 2017. 2. 7..
//  Copyright © 2017년 Trophy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        let userPhone = userPhoneTextField.text;
        let userPassword = userPasswordTextField.text;
        
        let userPhoneStored = NSUserDefaults.standardUserDefaults().stringForKey("userPhone")
        
        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
        
        if(userPhoneStored == userPhone) {
            if(userPasswordStored == userPassword) {
                // Login is successful
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn");
                NSUserDefaults.standardUserDefaults().synchronize();
                self.dismissViewControllerAnimated(true, completion: nil);
                
                
                
            }
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
