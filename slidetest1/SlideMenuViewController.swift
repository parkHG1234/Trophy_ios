//
//  SlideMenuViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 8..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SCLAlertView

class SlideMenuViewController: UIViewController {

    
    @IBOutlet weak var Profile: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var slideMenuWidthConstraint: NSLayoutConstraint!
    
    var isUserLoggedIn:Bool = false
    var Pk:String = ""
    var Name:String = ""
    var ProfileName:String = ""
    var arrRes: [[String:AnyObject]] = []
    
    override func viewDidAppear(_ animated: Bool) {
        setProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        Pk = UserDefaults.standard.string(forKey: "Pk")!
        
        
        //self.revealViewController().rearViewRevealWidth = self.view.frame.width - 100
        DispatchQueue.main.async(execute: {
            self.Profile.layer.cornerRadius = self.Profile.frame.size.width/2
            self.Profile.clipsToBounds = true
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        if(isUserLoggedIn) {
            SCLAlertView().showNotice("로그아웃 되었습니다", subTitle: "감사합니다")
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.setValue(".", forKey: "Pk")
            UserDefaults.standard.synchronize()
            
            setProfile()
        }else {
            SCLAlertView().showError("아직 로그인을 하지 않았네요!", subTitle: "로그인창에서 로그인을 해주세요")
        }
    }
    
    @IBAction func profileButtonTapped(_ sender: AnyObject) {
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(isUserLoggedIn == true) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "changePersonalInfoNavigationController")
            self.present(vc!, animated: false, completion: nil)
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginNavigationController")
            self.present(vc!, animated: false, completion: nil)
        }
    }
    
    @IBAction func goMainButtonTapped(_ sender: Any) { // 메인으로
        let revealViewController:SWRevealViewController = self.revealViewController()
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController")
        let newFrontViewController = UINavigationController.init(rootViewController:desController)
        revealViewController.pushFrontViewController(newFrontViewController, animated: true)
    }
    
    @IBAction func goCurrentContestButtonTapped(_ sender: Any) { // 진행중인대회
        let revealViewController:SWRevealViewController = self.revealViewController()
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "ContestViewController")
        let newFrontViewController = UINavigationController.init(rootViewController:desController)
        revealViewController.pushFrontViewController(newFrontViewController, animated: true)
    }
    
    @IBAction func goTeamSearch(_ sender: Any) {
        let revealViewController:SWRevealViewController = self.revealViewController()
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "SlideMenu_TeamSearch_TableViewController")
        let newFrontViewController = UINavigationController.init(rootViewController:desController)
        revealViewController.pushFrontViewController(newFrontViewController, animated: true)
    }
    
    @IBAction func goExContest(_ sender: Any) {
    }

    @IBAction func goTeamRank(_ sender: Any) {
        let revealViewController:SWRevealViewController = self.revealViewController()
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "SlideMenuTeamRankViewController")
        let newFrontViewController = UINavigationController.init(rootViewController:desController)
        revealViewController.pushFrontViewController(newFrontViewController, animated: true)
    }
    func setProfile() {
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(isUserLoggedIn) {
            // Do any additional setup after loading the view.
            Pk = UserDefaults.standard.string(forKey: "Pk")!
            Alamofire.request("http://210.122.7.193:8080/Trophy_part3/ChangePersonalInfo.jsp?Data1=\(Pk)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    print(swiftyJsonVar)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    
                    if(self.arrRes.count > 0) {
                        self.Name = self.arrRes[0]["Name"] as! String
                        self.ProfileName = self.arrRes[0]["Profile"] as! String
                        
                        if (self.ProfileName != ".") {
                            Alamofire.request("http://210.122.7.193:8080/Trophy_img/profile/\(self.ProfileName).jpg")
                                .responseImage { response in
                                    if let image = response.result.value {
                                        print("image downloaded: \(image)")
                                        // Store the commit date in to our cache
                                        // Update the cell
                                        DispatchQueue.main.async(execute: {
                                            if(self.Profile != nil) {
                                                self.Profile.image = image
                                            }
                                        });
                                    }
                            }
                        }
                        if(self.profileButton != nil) {
                            self.profileButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
                            self.profileButton.setTitle("\(self.Name)님 접속을 환영합니다", for: .normal)
                        }
                    }
                }
            }
        }else {
            // Do any additional setup after loading the view.
            Profile.image = UIImage(named: "user_basic")
            profileButton.setTitle("로그인을 해주세요", for: UIControlState())
            profileButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        }
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
