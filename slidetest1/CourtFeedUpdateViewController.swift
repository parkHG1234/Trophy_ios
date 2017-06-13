//
//  CourtFeedUpdateViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 5. 10..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class CourtFeedUpdateViewController: UIViewController {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var courtFeedTextView: UITextView!
    
    var arrRes = [[String:AnyObject]]()
    
    var userPk:String = ""
    var courtPk:String = ""
    
    var userName:String = ""
    var userProfile:String = ""
    
    var currentDate:String = ""
    var courtFeedContent:String = ""
    
    let dateformatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courtFeedTextView.delegate = self
        courtFeedTextView.text = "몇시에 몇명이서 오실껀가요?"
        courtFeedTextView.textColor = UIColor.lightGray
        
        dateformatter.dateFormat = "yyyy / MM / dd:::HH : mm"
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        courtPk = UserDefaults.standard.string(forKey: "courtPk")!
        
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/ChangePersonalInfo.jsp?Data1=\(userPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if(self.arrRes.count > 0) {
                    self.userName = self.arrRes[0]["Name"] as! String
                    self.userProfile = self.arrRes[0]["Profile"] as! String
                    
                    if (self.userProfile != ".") {
                        Alamofire.request("http://210.122.7.193:8080/Trophy_img/profile/\(self.userProfile).jpg")
                            .responseImage { response in
                                if let image = response.result.value {
                                    DispatchQueue.main.async(execute: {
                                        self.userProfileImageView.image = image
                                    });
                                }
                        }
                    }
                    self.userNameLabel.text = self.userName
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if courtFeedTextView.textColor == UIColor.lightGray {
            courtFeedTextView.text = nil
            courtFeedTextView.textColor = UIColor.black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if courtFeedTextView.text.isEmpty {
            courtFeedTextView.text = "몇시에 몇명이서 오실껀가요?"
            courtFeedTextView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        let date:NSDate = NSDate()
        currentDate = dateformatter.string(from: date as Date)
        courtFeedContent = courtFeedTextView.text
        
        print("currentDate = \(currentDate)")
        print("courtFeedContent = \(courtFeedContent)")
        
        let url = "http://210.122.7.193:8080/Trophy_part3/CourtFeedUpdate.jsp?Data1=\(userPk)&Data2=\(courtPk)&Data3=\(currentDate)&Data4=\(courtFeedContent)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if(self.arrRes.count > 0) {
                }
            }
        }
        print("courtPk : \(self.courtPk)")
        self.dismiss(animated: true, completion: nil)
    }
}
