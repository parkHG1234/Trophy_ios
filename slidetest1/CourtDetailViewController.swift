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

class feedCell: UICollectionViewCell {
    
}

class CourtDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var courtCollectionView: UICollectionView!
    
    var feedCell:UICollectionViewCell?
    var courtPk:String = ""
    
    var courtName:String = ""
    var courtAddressDo:String = ""
    var courtAddressSi:String = ""
    var courtImage:String = ""
    var courtIntroModifier:String = ""
    var courtIntro:String = ""
    var courtIntroModifyDate:String = ""
    
    var isUserLoggedIn:Bool = false
    var isScrollFinished:Bool = false
    var userPk:String = ""
    
    var feedSetting = CourtFeedSetting()
    var feedList:[CourtFeedSetting] = []
    
    var willDeleteFeedPk:String = ""
    
    var arrRes:[[String:AnyObject]] = []
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        courtCollectionView.delegate = self
        courtCollectionView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        
        feedList = []
        
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
    
    func deleteButtonTapped(sender: UIButton) {
        //if (userPk == feedList[indexPath.row].userPk) {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
            let deleteButton = UIAlertAction(title: "삭제", style: UIAlertActionStyle.destructive, handler: { (deleteSeleted) -> Void in
                let courtFeedPk = sender.accessibilityHint!
                
                Alamofire.request("http://210.122.7.193:8080/Trophy_part3/CourtFeedDelete.jsp?Data1=\(courtFeedPk)").responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                            print(self.arrRes)
                        }
                    }
                    self.viewDidAppear(false)
                }
                
            })
            actionSheet.addAction(deleteButton)
            
            let cancelButton = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: { (cancelSeleted) -> Void in
                
            })
            actionSheet.addAction(cancelButton)
            
            self.present(actionSheet, animated: true, completion: nil)
            
        //}else {
         //   return
        //}
    }
    
    func userInfoButtonTapped(_ sender: UITapGestureRecognizer) {
        let userPk = sender.accessibilityHint!
        print(userPk)
        
    }
    
    func headerImageTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    //상태 업데이트
    func updateFeedButtonTapped() {
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if(isUserLoggedIn) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourtUpdateFeedNavigationController")
            present(vc!, animated: true, completion: nil)
        }else {
            let myAlert = UIAlertController(title: "오늘의농구", message: "로그인이 필요합니다", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    //코트 소개 변경
    func updateIntroButtonTapped() {
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if(isUserLoggedIn) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourtIntroUpdateNavigationController")
            present(vc!, animated: true, completion: nil)
        }else {
            let myAlert = UIAlertController(title: "오늘의농구", message: "로그인이 필요합니다", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    // 네비게이션 아이템
    @IBAction func addButtonTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let courtApplicationButton = UIAlertAction(title: "코트사진 변경 신청", style: UIAlertActionStyle.destructive, handler: { (applicationSeleted) -> Void in
            
            self.isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
            
            if(self.isUserLoggedIn) {
                
            }else {
                let myAlert = UIAlertController(title: "오늘의농구", message: "로그인이 필요합니다", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
            }
        })
        actionSheet.addAction(courtApplicationButton)
        
        let cancelButton = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: { (cancelSeleted) -> Void in
        })
        
        actionSheet.addAction(cancelButton)
        
        self.present(actionSheet, animated: true, completion: nil)
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
        let feedDeleteButton = cell.viewWithTag(5) as! UIButton
        
        userNameLabel.text = feedList[indexPath.row].userName
        //feedDateLabel.text = feedList[indexPath.row].feedDate
        feedDateLabel.text = "1시간전"
        feedContentTextView.text = feedList[indexPath.row].feedContent
        
        feedDeleteButton.accessibilityHint = "\(feedList[indexPath.row].courtFeedPk)"
        feedDeleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userInfoButtonTapped))
        tapGesture.accessibilityHint = "\(feedList[indexPath.row].userPk)"
        
        if(self.userPk == feedList[indexPath.row].userPk) {
            feedDeleteButton.isHidden = false
        }else {
            feedDeleteButton.isHidden = true
        }
        
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
        
        userProfileImageView.isUserInteractionEnabled = true
        userNameLabel.isUserInteractionEnabled = true
        userProfileImageView.addGestureRecognizer(tapGesture)
        userNameLabel.addGestureRecognizer(tapGesture)
        
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
        
        headerIntroModifyButton.addTarget(self, action: #selector(updateIntroButtonTapped), for: .touchUpInside)
        headerUploadFeedButton.addTarget(self, action: #selector(updateFeedButtonTapped), for: .touchUpInside)
        
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
            headerImageImageVIew.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 55/255, alpha: 1)
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
        
        return CGSize(width: view.frame.width, height: 218 + rect.height + 12 + 54 + 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //57
        let size = CGSize(width: view.frame.width, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let rect = NSString(string: feedList[indexPath.row].feedContent).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: view.frame.width, height: 57 + rect.height + 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastCell = feedList.count - 1
        if indexPath.row == lastCell {
            let lastFeedPk = feedList[feedList.count - 1].courtFeedPk
            
            if (isScrollFinished == false) {
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                Alamofire.request("http://210.122.7.193:8080/Trophy_part3/CourtContentMore.jsp?Data1=\(self.courtPk)&Data2=\(lastFeedPk)").responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                        }
                        
                        if self.arrRes.count > 0 {
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
                        }else {
                            self.isScrollFinished = true
                        }
                        self.courtCollectionView.reloadData()
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
            }else {
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserDefaults.standard.setValue(self.courtPk, forKey: "courtPk")
        UserDefaults.standard.synchronize()
        if(segue.identifier == "goFeedUpdate") {
            if(userPk == "." || userPk == "") {
                return
            }
        }
    }
    
}
