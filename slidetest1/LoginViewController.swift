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
        let userPhone:String = userPhoneTextField.text!;
        let userPassword:String = userPasswordTextField.text!;
        
        if(userPhone.isEmpty || userPassword.isEmpty) { return; }
        
        
        //Send user data to server side
        let request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part3/Login_Confirm_ios.jsp")!);
        request.HTTPMethod = "POST";
        
        let postString = "Data1=\(userPhone)&Data2=\(userPassword)";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in guard error == nil && data != nil else {       // check for fundamental networking error
            print("error=\(error)")
            return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            
            var json:NSDictionary?;
            
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
            } catch let error as NSError {
                print("error : \(error)")
            }
            
            if let parseJSON = json {
                let resultValue = parseJSON["status"] as? String
                print("result: \(resultValue)")
                
                let Pk = parseJSON["Pk"] as? String
                print("Pk: \(Pk)")
                
                if(resultValue=="success") {
                    
                    //Login is successful
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                    NSUserDefaults.standardUserDefaults().setValue(Pk, forKey: "Pk")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }

            
            }
        }
        task.resume()
        
        
        
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
