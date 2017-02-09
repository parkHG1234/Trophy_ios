//
//  RegisterPageViewController.swift
//  TrophyProject
//
//  Created by ldong on 2017. 2. 7..
//  Copyright © 2017년 Trophy. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {
    
    
    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        
        let userPhone:String = userPhoneTextField.text!;
        let userPassword:String = userPasswordTextField.text!;
        let userRepeatPassword:String = repeatPasswordTextField.text!;
        
        //Check for Empty fields
        if(userPhone.isEmpty || userPassword.isEmpty || userRepeatPassword.isEmpty) {
            displayMyAlertMessage("All fields are required");
            return;
        }
        
        //Check if passwords match
        if(userPassword != userRepeatPassword) {
            displayMyAlertMessage("Passwords do not match");
            return;
        }
     
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part3/Join.jsp")!);
        request.HTTPMethod = "POST";
        
        let postString = "Data1=동석쨩&Data2=\(userPassword)&Data3=1993 / 6 / 22&Data4=M&Data5=경기도&Data6=테스트시&Data7=\(userPhone)";
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
                
                var isUserRegistered:Bool = false
                if(resultValue=="success") { isUserRegistered = true }
                
                var messageToDisplay:String = parseJSON["message"] as! String!;
                if(!isUserRegistered) {
                    messageToDisplay = parseJSON["message"] as! String!;
                }
                
                
                dispatch_async(dispatch_get_main_queue(),{
                    
                    //Display alert message with confirmation.
                    let myAlert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        action in
                        self.dismissViewControllerAnimated(true, completion: nil);
                    }
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                });
            }
        }
        task.resume()
    }
    
    
    func displayMyAlertMessage(userMessage:String) {
        let myAlert = UIAlertController(title: "a", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
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
