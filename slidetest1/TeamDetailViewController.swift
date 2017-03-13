//
//  TeamDetailViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 3. 9..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class TeamDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamAddressDoLabel: UILabel!
    @IBOutlet weak var teamAddressSiLabel: UILabel!
    @IBOutlet weak var teamHomeCourtLabel: UILabel!
    @IBOutlet weak var teamIntroduceLabel: UITextView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var teamEmblemImageView: UIImageView!
    
    @IBOutlet weak var teamImageView1: UIImageView!
    @IBOutlet weak var teamImageView2: UIImageView!
    @IBOutlet weak var teamImageView3: UIImageView!
    
    
    @IBOutlet weak var teamImage1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var teamImage2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var teamImage3HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var teamUserCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var teamUserColletionView: UICollectionView!
    
    
    
    var teamPk:String = ""
    var teamName:String = ""
    var teamEmblem:String = ""
    var teamAddressDo:String = ""
    var teamAddressSi:String = ""
    var teamHomeCourt:String = ""
    var teamIntroduce:String = ""
    var teamImage1:String = ""
    var teamImage2:String = ""
    var teamImage3:String = ""
    var teamImageList:[String] = []
    var teamImageViewList:[UIImageView] = []
    var teamImageViewConstraintList:[NSLayoutConstraint] = []
    var imageXPosition:Int = 0
    
    
    var teamUsers = TeamUserSetting()
    var teamUserList:[TeamUserSetting] = []
    var arrRes:[[String:AnyObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamUserCollectionViewHeightConstraint.constant = 0
        subViewHeightConstraint.constant = 500
        //498
        imageXPosition = 407
        
        teamImageList = [teamImage1, teamImage2, teamImage3]
        teamImageViewList = [teamImageView1, teamImageView2, teamImageView3]
        teamImageViewConstraintList = [teamImage1HeightConstraint, teamImage2HeightConstraint, teamImage3HeightConstraint]
        
        teamNameLabel.text = teamName
        teamIntroduceLabel.text = teamIntroduce
        teamAddressDoLabel.text = teamAddressDo
        teamAddressSiLabel.text = teamAddressSi
        teamHomeCourtLabel.text = teamHomeCourt
        
        teamUserColletionView.dataSource = self
        teamUserColletionView.delegate = self
        
        
        for i in 0 ..< 3 {
            if (self.teamImageList[i] != ".") {
                Alamofire.request("http://210.122.7.193:8080/Trophy_img/team/\(teamImageList[i]).jpg")
                    .responseImage { response in
                        //debugPrint(response)
                        //print(response.request)
                        //print(response.response)
                        //debugPrint(response.result)
                        DispatchQueue.main.async(execute: {
                            if let image = response.result.value {
                                self.subViewHeightConstraint.constant += 360
                                self.teamImageViewList[i].image = image
                                self.teamImageViewList[i].contentMode = .scaleToFill
                                self.teamImageViewList[i].frame.size.width = self.view.frame.width
                                self.teamImageViewList[i].frame.size.height = 360
                                self.teamImageViewList[i].frame.origin.x = 0
                                self.teamImageViewList[i].frame.origin.y = CGFloat(self.imageXPosition)
                                self.imageXPosition += 360
                            }
                        });
                }
            }else {
                teamImageViewConstraintList[i].constant = 0
            }
        }
        
        if(self.teamImageList[0] == "." && self.teamImageList[1] == "." && self.teamImageList[2] == ".") {
            
        }
        
        
        if(teamEmblem != ".") {
            Alamofire.request("http://210.122.7.193:8080/Trophy_img/team/\(teamEmblem).jpg")
                .responseImage { response in
                    DispatchQueue.main.async(execute: {
                        if let image = response.result.value {
                            debugPrint(response)
                            self.teamEmblemImageView.image = image
                        }
                    });
            }
        }
        
        //팀원정보
        let url:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/TeamUserSearch.jsp?Data1=\(teamPk)")!;
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("\(self.arrRes)")
                }
                self.teamUserCollectionViewHeightConstraint.constant += CGFloat(155 * ((self.arrRes.count % 3)+1))
                self.subViewHeightConstraint.constant += CGFloat(155 * ((self.arrRes.count % 3)+1))
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        self.teamUsers = TeamUserSetting()
                        self.teamUsers.userPk = dict["_Pk"] as! String
                        self.teamUsers.userName = dict["_Name"] as! String
                        self.teamUsers.userTeamDuty = dict["_TeamDuty"] as! String
                        self.teamUsers.userAddressDo = dict["_AddressDo"] as! String
                        self.teamUsers.userAddressSi = dict["_AddressSi"] as! String
                        self.teamUsers.userSex = dict["_Sex"] as! String
                        let img = dict["_Image"] as! String
                        if(img != ".") {
                            Alamofire.request("http://210.122.7.193:8080/Trophy_img/profile/\(img).jpg")
                                .responseImage { response in
                                    debugPrint(response.result)
                                    DispatchQueue.main.async(execute: {
                                        if let image = response.result.value {
                                            debugPrint(response)
                                            self.teamUsers.userImage = image
                                            self.teamUserColletionView.reloadData()
                                        }
                                    });
                            }
                        }
                        self.teamUserList.append(self.teamUsers)
                    }
                }
                
            }
        }
    }
    
    func setupTeamUserCollectionView() {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.teamUserList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamUserCell", for: indexPath) as UICollectionViewCell
        
        
        let teamUserImageView = cell.viewWithTag(1) as! UIImageView
        let teamUserNameLabel = cell.viewWithTag(2) as! UILabel
        
        teamUserImageView.image = teamUserList[indexPath.row].userImage
        teamUserNameLabel.text = teamUserList[indexPath.row].userName
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(view.frame.size.width/3), height: CGFloat(150))
    }
}





