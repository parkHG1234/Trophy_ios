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

struct cellData {
    let menuCell:Int!
    let menuTitle:String!
    let menuImage:UIImage!
}

class SlideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var Profile: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var slideMenuWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuTableView: UITableView!
    
    var isUserLoggedIn:Bool = false
    var Pk:String = ""
    var Name:String = ""
    var ProfileName:String = ""
    var ProfileImage:Data? = nil
    
    var arrCell = [cellData]()
    var arrRes: [[String:AnyObject]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // front view 터치 x
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
        revealViewController().frontViewController.view.backgroundColor = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        Pk = UserDefaults.standard.string(forKey: "Pk")!
        
        if(isUserLoggedIn) {
            arrCell = [cellData(menuCell:1, menuTitle:"메인으로", menuImage:#imageLiteral(resourceName: "ic_home")),
                       cellData(menuCell:11, menuTitle:"교류전", menuImage:#imageLiteral(resourceName: "ic_cast_connected")),
                       cellData(menuCell:12, menuTitle:"실시간 야외코트", menuImage:#imageLiteral(resourceName: "ic_cast")),
                       cellData(menuCell:2, menuTitle:"진행중인대회", menuImage:#imageLiteral(resourceName: "ic_event_note")),
                       cellData(menuCell:6, menuTitle:"지난대회보기", menuImage:#imageLiteral(resourceName: "ic_insert_invitation")),
                       cellData(menuCell:3, menuTitle:"팀 정보", menuImage:#imageLiteral(resourceName: "ic_people")),
                       cellData(menuCell:7, menuTitle:"랭킹", menuImage:#imageLiteral(resourceName: "ic_poll")),
                       cellData(menuCell:9, menuTitle:"공지사항", menuImage:#imageLiteral(resourceName: "ic_notifications")),
                       cellData(menuCell:10, menuTitle:"문의사항", menuImage:#imageLiteral(resourceName: "ic_insert_comment")),
                       cellData(menuCell:8, menuTitle:"로그아웃", menuImage:#imageLiteral(resourceName: "ic_person_outline"))]
        }else {
            arrCell = [cellData(menuCell:1, menuTitle:"메인으로", menuImage:#imageLiteral(resourceName: "ic_home")),
                       cellData(menuCell:11, menuTitle:"교류전", menuImage:#imageLiteral(resourceName: "ic_cast_connected")),
                       cellData(menuCell:12, menuTitle:"실시간 야외코트", menuImage:#imageLiteral(resourceName: "ic_cast")),
                       cellData(menuCell:2, menuTitle:"진행중인대회", menuImage:#imageLiteral(resourceName: "ic_event_note")),
                       cellData(menuCell:6, menuTitle:"지난대회보기", menuImage:#imageLiteral(resourceName: "ic_insert_invitation")),
                       cellData(menuCell:3, menuTitle:"팀 정보", menuImage:#imageLiteral(resourceName: "ic_people")),
                       cellData(menuCell:7, menuTitle:"랭킹", menuImage:#imageLiteral(resourceName: "ic_poll")),
                       cellData(menuCell:9, menuTitle:"공지사항", menuImage:#imageLiteral(resourceName: "ic_notifications")),
                       cellData(menuCell:10, menuTitle:"문의사항", menuImage:#imageLiteral(resourceName: "ic_insert_comment"))]
        }
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileTapped(tapGestureRecognizer:)))
        Profile.isUserInteractionEnabled = true
        Profile.addGestureRecognizer(tapGestureRecognizer)
        
        //self.revealViewController().rearViewRevealWidth = self.view.frame.width - 100
        DispatchQueue.main.async(execute: {
            self.Profile.layer.cornerRadius = self.Profile.frame.size.width/2
            self.Profile.clipsToBounds = true
        })
    }
    
    func profileTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let libButton = UIAlertAction(title: "라이브러리에서 선택", style: UIAlertActionStyle.default, handler: { (libSelected) -> Void in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        })
        actionSheet.addAction(libButton)
        let cameraButton = UIAlertAction(title: "사진 찍기", style: UIAlertActionStyle.default, handler: { (cameraSeleted) -> Void in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickerController, animated: true, completion: nil)
        })
        actionSheet.addAction(cameraButton)
        let cancelButton = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: { (cancelSeleted) -> Void in
            
        })
        actionSheet.addAction(cancelButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            Profile.image = image
            
            ProfileImage = UIImageJPEGRepresentation(image, 0.5)
            
            let url = "http://210.122.7.193:8080/Trophy_part3/ChangeProfileImage.jsp?Data1=\(Pk)&Data2=\(Pk)"
            Alamofire.request(url).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    self.uploadWithAlamofire(self.Pk)
                }
            }
        }else {
            print("error")
        }
        //myimage.backgroundColor = UIColor.clearColor()
        self.dismiss(animated: true, completion: nil)
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
                            self.profileButton.setTitle("\(self.Name)\n마동쿠스부라더스", for: .normal)
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
    
    func moveViewByReveal(sender: String) {
        let revealViewController:SWRevealViewController = self.revealViewController()
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: sender)
        let newFrontViewController = UINavigationController.init(rootViewController:desController)
        revealViewController.pushFrontViewController(newFrontViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")
        
        let menuImage = cell?.viewWithTag(1) as! UIImageView
        let menuLabel = cell?.viewWithTag(2) as! UILabel
        
        menuImage.image = arrCell[indexPath.row].menuImage
        menuLabel.text = arrCell[indexPath.row].menuTitle
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrCell[indexPath.row].menuCell == 1 {
            moveViewByReveal(sender: "ViewController")
        }else if arrCell[indexPath.row].menuCell == 2 {
            moveViewByReveal(sender: "ContestViewController")
        }else if arrCell[indexPath.row].menuCell == 3 {
            
        }else if arrCell[indexPath.row].menuCell == 4 {
            
        }else if arrCell[indexPath.row].menuCell == 5 {
            moveViewByReveal(sender: "SlideMenu_TeamSearch_TableViewController")
        }else if arrCell[indexPath.row].menuCell == 6 {
            
        }else if arrCell[indexPath.row].menuCell == 7 {
            moveViewByReveal(sender: "SlideMenuTeamRankViewController")
        }else if arrCell[indexPath.row].menuCell == 8 {
            if(isUserLoggedIn) {
                SCLAlertView().showNotice("로그아웃 되었습니다", subTitle: "감사합니다")
                UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                UserDefaults.standard.setValue(".", forKey: "Pk")
                UserDefaults.standard.synchronize()
                
                setProfile()
            }else {
                SCLAlertView().showError("아직 로그인을 하지 않았네요!", subTitle: "로그인창에서 로그인을 해주세요")
            }
        }else if arrCell[indexPath.row].menuCell == 9 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoticeNavigationController")
            self.present(vc!, animated: true, completion: nil)
        }else if arrCell[indexPath.row].menuCell == 10 {
            isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
            if (isUserLoggedIn) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecommendViewController")
                self.present(vc!, animated: true, completion: nil)
            }else {
                //로그인 필요 알림
            }
            
        }else if arrCell[indexPath.row].menuCell == 11 {
            moveViewByReveal(sender: "MatchViewController")
        }else if arrCell[indexPath.row].menuCell == 12 {
            moveViewByReveal(sender: "CourtViewController")
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func uploadWithAlamofire(_ profile:String) {
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(self.ProfileImage!, withName: "file" , fileName: "\(profile).jpg", mimeType: "image/jpg")},
                         to: "http://210.122.7.193:8080/Trophy_part3/UserImageUpload.jsp",
                         method: .post,
                         headers: ["Authorization": "auth_token"],
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.response { [weak self] response in
                                    guard let strongSelf = self else {
                                        return
                                    }
                                    debugPrint(response)
                                }
                            case .failure(let encodingError):
                                print("error:\(encodingError)")
                            }
        })
    }
}
