//

//  Contest_Detail_ViewController.swift

//  slidetest1

//

//  Created by MD313-007 on 2017. 2. 14..

//  Copyright © 2017년 MD313-008. All rights reserved.

//



import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON


class Contest_Detail_ViewController: UIViewController , UISearchResultsUpdating {
    

    
    @IBOutlet weak var Detail_Image: UIImageView!
    @IBOutlet weak var Detail_Title: UILabel!
    @IBOutlet weak var Detail_Host: UILabel!
    @IBOutlet weak var Detail_Management: UILabel!
    @IBOutlet weak var Detail_Support: UILabel!
    @IBOutlet weak var Detail_Payment: UILabel!
    @IBOutlet weak var Detail_RecruitStartDate: UILabel!
    @IBOutlet weak var Detail_ContestDate: UILabel!
    @IBOutlet weak var Detail_Place: UILabel!
    
    @IBOutlet weak var Detail_DetailInfo: UITextView!
    
    @IBOutlet var Contest_ScrollView: UIScrollView!
    
    @IBOutlet weak var ConfrimButton: UIButton!
    
    @IBOutlet weak var WarnningHeightConstraint: NSLayoutConstraint!
    
    
    var isUserLoggedIn:Bool = false
    var isTeamManager:Bool = false
    var userPk:String = ""
    var teamPk:String = ""
    
    var Contest_Pk:String = ""
    var Contest_Title:String = ""
    var Contest_Image:String = ""
    var Contest_CurrentNum:String = ""
    var Contest_MaxNum:String = ""
    var Contest_Payment:String = ""
    var Contest_Host:String = ""
    var Contest_Management:String = ""
    var Contest_Support:String = ""
    var Contest_ContestDate:String = ""
    var Contest_RecruitStartDate:String = ""
    var Contest_RecruitFinishDate:String = ""
    var Contest_DetailInfo:String = ""
    var Contest_Place:String = ""
    
    var arrRes = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        
        //Make BackGround Detail Information
        
        //네비게이션바 뒤로가기 버튼
//        let yourBackImage = UIImage(named: "cm_arrow_back_white")
//        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        
        //기본 설정
        Detail_Title.text = Contest_Title
        Detail_Host.text = Contest_Host
        Detail_Management.text = Contest_Management
        Detail_Support.text = Contest_Support
        Detail_Payment.text = Contest_Payment
        Detail_RecruitStartDate.text = Contest_RecruitStartDate
        Detail_ContestDate.text = Contest_ContestDate
        Detail_Place.text = Contest_Place
        Detail_DetailInfo.text = Contest_DetailInfo
        
        //Contest_ScrollView.contentSize.height = 1000
        
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        
        
        if(isUserLoggedIn) { //팀 대표인지 확인 후 팀 대표면 대회신청가능
            let url:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/isTeamManager.jsp?Data1=\(userPk)")!;
            Alamofire.request(url).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                        let teamDuty:String = self.arrRes[0]["Team_Duty"] as! String
                        if(teamDuty == "팀대표") {
                            self.isTeamManager = true
                            self.teamPk = self.arrRes[0]["Team_Pk"] as! String
                            
                            self.ConfrimButton.isEnabled = true
                            self.ConfrimButton.backgroundColor = UIColor(red: 255.0/255.0, green: 181.0/255.0, blue: 84.0/255.0, alpha: 1.0)
                            
                            self.WarnningHeightConstraint.constant = 0
                        }else {
                            self.isTeamManager = false
                            
                            self.ConfrimButton.isEnabled = false // 팀대표만 신청 가능 표시
                            self.ConfrimButton.backgroundColor = UIColor.gray
                            self.WarnningHeightConstraint.constant = 20
                        }
                    }
                }
            }
        }else {
            ConfrimButton.isEnabled = false //로그인 되지 않음 표시
            ConfrimButton.backgroundColor = UIColor.gray
            self.WarnningHeightConstraint.constant = 20
        }
        
        
        
        
        //대회 사진 다운로드
        Alamofire.request("http://210.122.7.193:8080/Trophy_img/contest/\(self.Contest_Image).jpg")
            .responseImage { response in
                if let image = response.result.value {
                    DispatchQueue.main.async(execute: {
                        self.Detail_Image.image = image
                    });
                }
        }
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        func Done(_ sender: AnyObject) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //뒤로가기버튼 글자 없애기
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        
        let Contest_Application_View = segue.destination as! Contest_Application_ViewController
        Contest_Application_View.User_Pk = userPk
        Contest_Application_View.Team_Pk = teamPk
        Contest_Application_View.Contest_Pk = Contest_Pk
        Contest_Application_View.Contest_Title = Contest_Title
        
    }
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        
    }
}
