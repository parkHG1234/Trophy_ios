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
    @IBOutlet weak var backButton: UIBarButtonItem!
    
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
    
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        let userPhone:String = userPhoneTextField.text!;
        let userPassword:String = userPasswordTextField.text!;
        
        if(userPhone.isEmpty || userPassword.isEmpty) { return; }
        
        
        //Send user data to server side
        let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part3/Login_Confirm_ios.jsp")!);
        request.httpMethod = "POST";
        
        let postString = "Data1=\(userPhone)&Data2=\(userPassword)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        
//        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in guard error == nil && data != nil else {       // check for fundamental networking error
//            print("error=\(error)")
//            return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
//            
//            let responseString:String = String(data: data!, encoding: String.Encoding.utf8)!
//            //print("responseString = \(responseString)")
//            
//            
//            var json:NSDictionary?;
//            
//            do {
//                json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//            } catch let error as NSError {
//                print("error : \(error)")
//            }
//            
//            if let parseJSON = json {
//                let resultValue:String = (parseJSON["status"] as? String)!
//                self._resultValue = resultValue
//                print("result: \(resultValue)")
//                
//                let Pk:String = (parseJSON["Pk"] as? String)!
//                self._Pk = Pk
//                print("Pk: \(self._Pk)")
//                
//                self.check = true
//
//            }
//            
//            
//            if(self._resultValue=="success") {
//                //Login is successful
//                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
//                UserDefaults.standard.setValue(self._Pk, forKey: "Pk")
//                UserDefaults.standard.synchronize()
//                self.dismiss(animated: true, completion: {
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SlideMenuViewController")
//                    vc?.reloadInputViews()
//                    vc?.viewDidLoad()
//                    self.present(vc!, animated: true, completion: nil)
//                })
//
//
//            }else if(self._resultValue=="not exsist") {
//                DispatchQueue.main.async(execute: {
//                    
//                    //Display alert message with confirmation.
//                    let myAlert = UIAlertController(title: "트로피", message: "등록되지 않은 휴대전화번호입니다", preferredStyle: UIAlertControllerStyle.alert)
//                    
//                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                        action in
//                    }
//                    myAlert.addAction(okAction)
//                    self.present(myAlert, animated: true, completion: nil)
//                });
//            }else {
//                DispatchQueue.main.async(execute: {
//                    
//                    //Display alert message with confirmation.
//                    let myAlert = UIAlertController(title: "트로피", message: "정확한 휴대전화번호 및 비밀번호를 입력해 주세요", preferredStyle: UIAlertControllerStyle.alert)
//                    
//                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                        action in
//                    }
//                    myAlert.addAction(okAction)
//                    self.present(myAlert, animated: true, completion: nil)
//                });
//            }
//            
//        }) 
//        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
