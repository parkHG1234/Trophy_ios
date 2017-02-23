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
    
    var _Pk:String = ""
    var _resultValue:String = ""
    var check:Bool = false
    
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
            
            let responseString:String = String(data: data!, encoding: NSUTF8StringEncoding)!
            //print("responseString = \(responseString)")
            
            
            var json:NSDictionary?;
            
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
            } catch let error as NSError {
                print("error : \(error)")
            }
            
            if let parseJSON = json {
                let resultValue:String = (parseJSON["status"] as? String)!
                self._resultValue = resultValue
                print("result: \(resultValue)")
                
                let Pk:String = (parseJSON["Pk"] as? String)!
                self._Pk = Pk
                print("Pk: \(self._Pk)")
                
                self.check = true

            }
            
            
            if(self._resultValue=="success") {
                //Login is successful
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                NSUserDefaults.standardUserDefaults().setValue(self._Pk, forKey: "Pk")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.dismissViewControllerAnimated(true, completion: {
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuViewController")
                    vc?.reloadInputViews()
                    vc?.viewDidLoad()
                    self.presentViewController(vc!, animated: true, completion: nil)
                })


            }else if(self._resultValue=="not exsist") {
                dispatch_async(dispatch_get_main_queue(),{
                    
                    //Display alert message with confirmation.
                    let myAlert = UIAlertController(title: "트로피", message: "등록되지 않은 휴대전화번호입니다", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        action in
                    }
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                });
            }else {
                dispatch_async(dispatch_get_main_queue(),{
                    
                    //Display alert message with confirmation.
                    let myAlert = UIAlertController(title: "트로피", message: "정확한 휴대전화번호 및 비밀번호를 입력해 주세요", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        action in
                    }
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                });
            }
            
        }
        task.resume()
    }
    

    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
}
