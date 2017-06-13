//
//  MatchDetailViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 23..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MatchDetailViewController: UIViewController {

    @IBOutlet weak var matchTitleLabel: UILabel!
    @IBOutlet weak var teamEmblemImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var matchStatusLabel: UILabel!
    @IBOutlet weak var matchDateTextField: UITextField!
    @IBOutlet weak var matchTimeTextField: UITextField!
    @IBOutlet weak var matchPlaceTextField: UITextField!
    @IBOutlet weak var matchPayTextField: UITextField!
    @IBOutlet weak var matchUniformTextField: UITextField!
    @IBOutlet weak var matchParkForbiddenView: UIView!
    @IBOutlet weak var matchParkFreeView: UIView!
    @IBOutlet weak var matchParkChargeView: UIView!
    @IBOutlet weak var matchDisplayView: UIView!
    @IBOutlet weak var matchShowerView: UIView!
    @IBOutlet weak var matchColdhotView: UIView!
    @IBOutlet weak var matchExtraTextView: UITextView!
    
    var matchPk:String = ""
    var userPk:String = ""
    var teamPk:String = ""
    var teamEmblem:String = ""
    var teamName:String = ""
    var matchUploadTime:String = ""
    var matchTitle:String = ""
    var matchDate:String = ""
    var matchTime:String = ""
    var matchPlace:String = ""
    var matchPay:String = ""
    var matchUniform:String = ""
    var matchStatus:String = ""
    var matchParkForbidden:String = ""
    var matchParkFree:String = ""
    var matchParkCharge:String = ""
    var matchDisplay:String = ""
    var matchShower:String = ""
    var matchColdhot:String = ""
    var matchExtra:String = ""
    
    var arrRes = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("bbb : \(self.matchPk)")
        
        self.teamEmblemImageView.layer.cornerRadius = self.teamEmblemImageView.frame.size.width/2
        self.teamEmblemImageView.clipsToBounds = true
        self.teamEmblemImageView.backgroundColor = UIColor.white

        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/MatchDetail.jsp?Data1=\(self.matchPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                print(responseData.result.value!)
                let swiftyJsonVar = JSON(responseData.result.value!)
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count > 0 {
                    self.matchPk = self.arrRes[0]["msg1"] as! String
                    self.userPk = self.arrRes[0]["msg2"] as! String
                    self.teamPk = self.arrRes[0]["msg3"] as! String
                    self.matchUploadTime = self.arrRes[0]["msg4"] as! String
                    self.matchTitle = self.arrRes[0]["msg5"] as! String
                    self.matchTime = self.arrRes[0]["msg6"] as! String
                    self.matchPlace = self.arrRes[0]["msg7"] as! String
                    self.matchParkForbidden = self.arrRes[0]["msg8"] as! String
                    self.matchParkFree = self.arrRes[0]["msg9"] as! String
                    self.matchParkCharge = self.arrRes[0]["msg10"] as! String
                    self.matchDisplay = self.arrRes[0]["msg11"] as! String
                    self.matchShower = self.arrRes[0]["msg12"] as! String
                    self.matchColdhot = self.arrRes[0]["msg13"] as! String
                    self.matchStatus = self.arrRes[0]["msg14"] as! String
                    self.teamEmblem = self.arrRes[0]["msg15"] as! String
                    self.teamName = self.arrRes[0]["msg16"] as! String
                    self.matchPay = self.arrRes[0]["msg17"] as! String
                    self.matchUniform = self.arrRes[0]["msg18"] as! String
                    self.matchExtra = self.arrRes[0]["msg19"] as! String
                    self.matchDate = self.arrRes[0]["msg20"] as! String
                    
                    self.matchTitleLabel.text = self.matchTitle
                    if (self.teamEmblem != ".") {
                        let url = "http://210.122.7.193:8080/Trophy_img/team/\(self.teamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                        Alamofire.request(url!)
                            .responseImage { response in
                                if let image = response.result.value {
                                    print("image downloaded: \(image)")
                                    // Store the commit date in to our cache
                                    // Update the cell
                                    DispatchQueue.main.async(execute: {
                                        if(self.teamEmblemImageView != nil) {
                                            self.teamEmblemImageView.image = image
                                        }
                                    });
                                }
                        }
                    }
                    self.teamNameLabel.text = self.teamName
                    self.matchStatusLabel.text = self.matchStatus
                    self.matchDateTextField.text = self.matchDate
                    self.matchTimeTextField.text = self.matchTime
                    self.matchPlaceTextField.text = self.matchPlace
                    self.matchPayTextField.text = self.matchPay
                    self.matchUniformTextField.text = self.matchUniform
                    if self.matchParkForbidden == "true" {
                        self.matchParkForbiddenView.backgroundColor = UIColor.lightGray
                    }
                    if self.matchParkFree == "true" {
                        self.matchParkFreeView.backgroundColor = UIColor.lightGray
                    }
                    if self.matchParkCharge == "true" {
                        self.matchParkChargeView.backgroundColor = UIColor.lightGray
                    }
                    if self.matchDisplay == "true" {
                        self.matchDisplayView.backgroundColor = UIColor.lightGray
                    }
                    if self.matchShower == "true" {
                        self.matchShowerView.backgroundColor = UIColor.lightGray
                    }
                    if self.matchColdhot == "true" {
                        self.matchColdhotView.backgroundColor = UIColor.lightGray
                    }
                    self.matchExtraTextView.text = self.matchExtra
                }
            }
        }
    }
    
    @IBAction func requestButtonTapped(_ sender: Any) {
        
    }
}
