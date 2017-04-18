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
    @IBOutlet weak var warnningHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var teamUserCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var teamUserColletionView: UICollectionView!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    var isUserLoggedIn:Bool = false
    var isMyTeam:Bool = false
    var isMyTeamManager:Bool = false
    var userPk:String = ""
    var _teamPk:String = ""
    
    var teamImageList:[String] = []
    var teamImageViewList:[UIImageView] = []
    var teamImageViewConstraintList:[NSLayoutConstraint] = []
    var imageXPosition:Int = 0
    var collectionViewCellHeight = 120
    
    
    var teamUsers = TeamUserSetting()
    var teamUserList:[TeamUserSetting] = []
    var arrRes:[[String:AnyObject]] = []
    var userState:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonTitleForDuty()
        
        teamUserCollectionViewHeightConstraint.constant = 0
        subViewHeightConstraint.constant = 520
        imageXPosition = 407
        
        teamEmblemImageView.layer.cornerRadius = teamEmblemImageView.frame.size.width/2
        teamEmblemImageView.clipsToBounds = true
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/TeamDetail.jsp?Data1=\(_teamPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("\(self.arrRes)")
                }
                
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        
                        let _teamName = dict["teamName"] as! String
                        let _teamIntroduce = dict["teamIntroduce"] as! String
                        let _teamAddressDo = dict["teamAddressDo"] as! String
                        let _teamAddressSi = dict["teamAddressSi"] as! String
                        let _teamHomeCourt = dict["teamHomeCourt"] as! String
                        let _teamImage1 = dict["teamImage1"] as! String
                        let _teamImage2 = dict["teamImage2"] as! String
                        let _teamImage3 = dict["teamImage3"] as! String
                        let _teamEmblem = dict["teamEmblem"] as! String
                        
                        self.teamImageList = [_teamImage1, _teamImage2, _teamImage3]
                        self.teamNameLabel.text = _teamName
                        self.teamIntroduceLabel.text = _teamIntroduce
                        self.teamAddressDoLabel.text = _teamAddressDo
                        self.teamAddressSiLabel.text = _teamAddressSi
                        self.teamHomeCourtLabel.text = _teamHomeCourt
                        
                        if(_teamEmblem != ".") {
                            let url = "http://210.122.7.193:8080/Trophy_img/team/\(_teamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            Alamofire.request(url!).responseImage { response in
                                if let image = response.result.value {
                                    print ("image download : \(image)")
                                    DispatchQueue.main.async(execute: {
                                        debugPrint(response)
                                        self.teamEmblemImageView.image = image
                                        self.teamEmblemImageView.reloadInputViews()
                                    });
                                }
                            }
                        }else {
                            self.teamEmblemImageView.image = UIImage(named: "ic_team")
                        }
                    }
                    self.setTeamImages()
                }
            }
        }
        
        teamImageViewList = [teamImageView1, teamImageView2, teamImageView3]
        teamImageViewConstraintList = [teamImage1HeightConstraint, teamImage2HeightConstraint, teamImage3HeightConstraint]
        
        teamUserColletionView.dataSource = self
        teamUserColletionView.delegate = self
        
        getTeamUsers()
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
        
        teamUserImageView.layer.cornerRadius = teamUserImageView.frame.size.width/5
        teamUserImageView.clipsToBounds = true
        
        
        if(teamUserList[indexPath.row].userImage != ".") {
            Alamofire.request("http://210.122.7.193:8080/Trophy_img/profile/\(teamUserList[indexPath.row].userImage).jpg")
                .responseImage { response in
                    debugPrint(response.result)
                    DispatchQueue.main.async(execute: {
                        if let image = response.result.value {
                            debugPrint(response)
                            teamUserImageView.image = image
                        }
                    });
            }
        }
        teamUserNameLabel.text = teamUserList[indexPath.row].userName
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(view.frame.size.width/4), height: CGFloat(collectionViewCellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! TeamUserDetailPopUpViewController
        popOverVC.teamUserName = teamUserList[indexPath.row].userName
        popOverVC.teamUserAge = teamUserList[indexPath.row].userBirth
        popOverVC.teamUserSex = teamUserList[indexPath.row].userSex
        popOverVC.teamUserAddressDo = teamUserList[indexPath.row].userAddressDo
        popOverVC.teamUserAddressSi = teamUserList[indexPath.row].userAddressSi
        popOverVC.teamUserPhone = teamUserList[indexPath.row].userPhone
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    @IBAction func confirmButtonTapped(_ sender: Any) {
        print(userState)
        if(userState == "isMyTeamManager") {
            //팀관리페이지
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeamManageTapContoller")
            self.present(vc!, animated: false, completion: nil)
            
        }else if(userState == "isMyTeam") {
            //팀탈퇴
        }else if(userState != ".") {
            //이미 가입된 팀이 있다고 표시
        }else if (userState == "."){
            //가입 신청
        }else { //로그인 안했을시
            
        }
    }
    
    
    func setButtonTitleForDuty() {
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(isUserLoggedIn) {
            userPk = UserDefaults.standard.string(forKey: "Pk")!
            Alamofire.request("http://210.122.7.193:8080/Trophy_part3/isMyTeam.jsp?Data1=\(userPk)&Data2=\(_teamPk)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                        print("\(self.arrRes)")
                        var dict = self.arrRes[0]
                        if((dict["isMyTeam"] as! String) == "isMyTeamManager") { //팀대표일시
                            self.userState = "isMyTeamManager"
                            //경고 없애기
                            self.warnningHeightConstraint.constant = 0
                            self.confirmButton.isEnabled = true
                            self.confirmButton.backgroundColor = UIColor(red: 233.0/255.0, green: 69.0/255.0, blue: 56.0/255.0, alpha: 1.0)
                            self.confirmButton.setTitle("팀관리", for: .normal)
                        }else if ((dict["isMyTeam"] as! String) == "isMyTeam") { //팀원일시
                            self.userState = "isMyTeam"
                            //경고 없애기
                            self.warnningHeightConstraint.constant = 0
                            //버튼 레드 && enable true && 버튼 text : 가입신청
                            self.confirmButton.isEnabled = true
                            self.confirmButton.backgroundColor = UIColor(red: 233.0/255.0, green: 69.0/255.0, blue: 56.0/255.0, alpha: 1.0)
                            self.confirmButton.setTitle("팀탈퇴", for: .normal)
                        }else { //팀원이 아닐시
                            if((dict["isMyTeam"] as! String) == ".") { //가입된 팀이 없을시
                                self.userState = "notJoinTeam"
                                //경고 없애기
                                self.warnningHeightConstraint.constant = 0
                                //버튼 레드 && enable true && 버튼 text : 가입신청
                                self.confirmButton.isEnabled = true
                                self.confirmButton.backgroundColor = UIColor.gray
                                self.confirmButton.setTitle("가입신청", for: .normal)
                            }else {//가입된 다른 팀이 있을시
                                self.userState = "notMyTeam"
                                //경고 없애기
                                self.warnningHeightConstraint.constant = 0
                                //버튼 레드 && enable true && 버튼 text : 가입신청
                                self.confirmButton.isEnabled = true
                                self.confirmButton.backgroundColor = UIColor.gray
                                self.confirmButton.setTitle("가입신청", for: .normal)
                            }
                        }
                    }
                }
            }
        }else { //로그인 안했을시
            userState = "notLoggedIn"
            //warnning : 로그인한 사용자만 가입신청 가능
            warnningHeightConstraint.constant = 20
            //버튼 회색 && enable false && 버튼 text : 가입신청
            confirmButton.backgroundColor = UIColor.gray
            confirmButton.isEnabled = false
            confirmButton.setTitle("가입신청", for: .normal)
        }
    }
    
    func setTeamImages() {
        if(self.teamImageList.count > 0) {
            for i in 0 ..< 3 {
                if (self.teamImageList[i] != ".") {
                    let url = "http://210.122.7.193:8080/Trophy_img/team/\(self.teamImageList[i]).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    Alamofire.request(url!)
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
                //등록된 사진 없음 표시
            }
        }
    }
    
    func getTeamUsers() {
        //팀원정보 받아오기
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/TeamUserSearch.jsp?Data1=\(_teamPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("\(self.arrRes)")
                }
                
                self.teamUserCollectionViewHeightConstraint.constant += CGFloat((self.collectionViewCellHeight+5) * ((self.arrRes.count % 4)+1))
                self.subViewHeightConstraint.constant += CGFloat((self.collectionViewCellHeight+5) * ((self.arrRes.count % 4)+1))
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        self.teamUsers = TeamUserSetting()
                        self.teamUsers.userPk = dict["_Pk"] as! String
                        self.teamUsers.userPhone = dict["_Phone"] as! String
                        self.teamUsers.userName = dict["_Name"] as! String
                        self.teamUsers.userTeamDuty = dict["_TeamDuty"] as! String
                        self.teamUsers.userBirth = dict["_Birth"] as! String
                        self.teamUsers.userAddressDo = dict["_AddressDo"] as! String
                        self.teamUsers.userAddressSi = dict["_AddressSi"] as! String
                        self.teamUsers.userSex = dict["_Sex"] as! String
                        self.teamUsers.userImage = dict["_Image"] as! String
                        self.teamUserList.append(self.teamUsers)
                    }
                    self.teamUserColletionView.reloadData()
                }
            }
        }
    }
}




    

