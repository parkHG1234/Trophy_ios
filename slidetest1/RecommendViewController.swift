//
//  RecommendViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 19..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecommendViewController: UIViewController {

    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var recommendTypeTextField: UITextField!
    @IBOutlet weak var recommendDataTextView: UITextView!
    
    var arrRes = [[String:AnyObject]]()
    
    var isUserLoggedIn:Bool = false
    var userPk:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/ChangePersonalInfo.jsp?Data1=\(userPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                //let name:String = (self.arrRes[0]["Name"] as? String)!
                let phone:String = (self.arrRes[0]["Phone"] as? String)!
                
                self.userPhoneLabel.text = phone
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commitButtonTapped(_ sender: Any) {
        
        let url = "http://210.122.7.193:8080/Trophy_part3/Suggest.jsp?Data1=\(userPk)&Data2=\(recommendDataTextView.text!)&Data3=\(userEmailTextField.text!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
