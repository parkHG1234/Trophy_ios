//
//  CourtDetailViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 5. 1..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class CourtDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var courtCollectionView: UICollectionView!
    
    var courtPk:String = ""
    
    var courtName:String = ""
    var courtAddressDo:String = ""
    var courtAddressSi:String = ""
    var courtImage:String = ""
    var courtIntroModifier:String = ""
    var courtIntro:String = ""
    var courtIntroModifyDate:String = ""
    
    var isUserLoggedIn:Bool = false
    var userPk:String = ""
    
    var feedSetting = CourtFeedSetting()
    var feedList:[CourtFeedSetting] = []
    
    var arrRes:[[String:AnyObject]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        courtCollectionView.delegate = self
        courtCollectionView.dataSource = self
        courtCollectionView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/CourtDetail.jsp?Data1=\(courtPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    var dict = self.arrRes[0]
                    
                    self.courtName = dict["msg1"] as! String
                    self.courtAddressDo = dict["msg2"] as! String
                    self.courtAddressSi = dict["msg3"] as! String
                    self.courtImage = dict["msg5"] as! String
                    self.courtIntro = dict["msg6"] as! String
                    self.courtIntroModifier = dict["msg7"] as! String
                    self.courtIntroModifyDate = dict["msg8"] as! String
                    
                }
                Alamofire.request("http://210.122.7.193:8080/Trophy_part3/CourtContent.jsp?Data1=\(self.courtPk)").responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                        }
                        
                        for i in 0 ..< self.arrRes.count {
                            var dict = self.arrRes[i]
                            
                            self.feedSetting = CourtFeedSetting()
                            
                            self.feedSetting.courtFeedPk = dict["msg1"] as! String
                            self.feedSetting.userPk = dict["msg3"] as! String
                            self.feedSetting.feedDate = dict["msg4"] as! String
                            self.feedSetting.feedContent = dict["msg5"] as! String
                            self.feedSetting.userName = dict["msg7"] as! String
                            self.feedSetting.userProfile = dict["msg6"] as! String
                            
                            self.feedList.append(self.feedSetting)
                        }
                        self.courtCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func modifyIntroTapped(sender: AnyObject) {
        // 코트 소개 변경 페이지로 이동
        print("tapped")
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath)
        
        let userProfileImageView = cell.viewWithTag(1) as! UIImageView
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        let feedDateLabel = cell.viewWithTag(3) as! UILabel
        let feedContentTextView = cell.viewWithTag(4) as! UITextView
        
        userNameLabel.text = feedList[indexPath.row].userName
        feedDateLabel.text = feedList[indexPath.row].feedDate
        feedContentTextView.text = feedList[indexPath.row].feedContent
        
        if(feedList[indexPath.row].userProfile != ".") {
            Alamofire.request("http://210.122.7.193:8080/Trophy_img/profile/\(feedList[indexPath.row].userProfile).jpg")
                .responseImage { response in
                    if let image = response.result.value {
                        DispatchQueue.main.async(execute: {
                            userProfileImageView.image = image
                        });
                    }
            }
        }else {
            userProfileImageView.image = UIImage(named: "user_basic")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        
        let headerImageImageVIew = headerView.viewWithTag(1) as! UIImageView
        let headerNameLabel = headerView.viewWithTag(2) as! UILabel
        let headerAddressDoLabel = headerView.viewWithTag(3) as! UILabel
        let headerAddressSiLabel = headerView.viewWithTag(4) as! UILabel
        let headerIntroModifierLabel = headerView.viewWithTag(5) as! UILabel
        let headerIntroModifyButton = headerView.viewWithTag(6) as! UIButton
        let headerIntroTextView = headerView.viewWithTag(7) as! UITextView
        let headerUserProfileImageView = headerView.viewWithTag(8) as! UIImageView
        let headerUploadFeedButton = headerView.viewWithTag(9) as! UIButton
        
        headerNameLabel.text = self.courtName
        headerAddressDoLabel.text = self.courtAddressDo
        headerAddressSiLabel.text = self.courtAddressSi
        headerIntroModifierLabel.text = "마지막 변경 : \(self.courtIntroModifier)"
        headerIntroTextView.text = self.courtIntro
        
        if(courtImage != ".") {
            Alamofire.request("http://210.122.7.193:8080/Trophy_img/court/\(courtImage).jpg")
                .responseImage { response in
                    if let image = response.result.value {
                        DispatchQueue.main.async(execute: {
                            headerImageImageVIew.image = image
                        });
                    }
            }
        }else {
            headerImageImageVIew.backgroundColor = UIColor(red: 26, green: 26, blue: 55, alpha: 0)
            headerImageImageVIew.image = nil
        }
        
        
        
        userPk = UserDefaults.standard.string(forKey: "Pk")!;

        if(userPk != ".") {
            Alamofire.request("http://210.122.7.193:8080/Trophy_img/profile/\(userPk).jpg")
                .responseImage { response in
                    if let image = response.result.value {
                        DispatchQueue.main.async(execute: {
                            headerUserProfileImageView.image = image
                        });
                    }
            }
        }else {
            headerImageImageVIew.image = UIImage(named: "user_basic")
        }
        
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let size = CGSize(width: view.frame.width, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let rect = NSString(string: courtIntro).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: view.frame.width, height: 218 + rect.height + 12 + 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //57
        let size = CGSize(width: view.frame.width, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let rect = NSString(string: feedList[indexPath.row].feedContent).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: view.frame.width, height: 57 + rect.height + 16)
    }
}
