//

//  ViewController.swift

//  slidetest1

//

//  Created by MD313-008 on 2017. 2. 7..

//  Copyright © 2017년 MD313-008. All rights reserved.

//



import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON



class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var open: UIBarButtonItem!
    
    @IBOutlet weak var scrollViewTop: UIScrollView!
    
    
    @IBOutlet weak var collectionViewRecentContest: UICollectionView!
    @IBOutlet weak var collectionViewMyRank: UICollectionView!
    @IBOutlet weak var collectionViewMyRankHeight: NSLayoutConstraint!
    
    var isUserLoggedIn:Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    var userPk:String = UserDefaults.standard.string(forKey: "Pk")!
    var teamPk:String = ""
    var timer:Timer?
    var indicatorTimer:Timer?
    
    var filteredData:[String] = []
    var Contest_Setting = Contest_Detail_Setting()
    var Contest_list:[Contest_Detail_Setting] = []
    
    var Rank_Setting = TeamRankSetting()
    var Rank_list:[TeamRankSetting] = []
    
    var arrRes = [[String: AnyObject]]()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidAppear(_ animated: Bool) {
        getRecentContest()
        getTeamRank()
        
        // 상단 스크롤 뷰 자동 넘기기
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.autoScroll), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(userPk.isEmpty) {
            UserDefaults.standard.setValue(".", forKey: "Pk")
            UserDefaults.standard.synchronize()
        }
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.indicatorTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(ViewController.stopIndicator), userInfo: nil, repeats: false)
        
        collectionViewRecentContest.delegate = self
        collectionViewMyRank.delegate = self
        collectionViewRecentContest.dataSource = self
        collectionViewMyRank.dataSource = self
        collectionViewMyRankHeight.constant = (view.frame.width / 4) + 20
        
        
        // 상단 트로피 그림
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Trophy_ic")
        navigationItem.titleView = imageView
        
        
        // drawer 설정
        if self.revealViewController() != nil {
            //self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func stopIndicator() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    func autoScroll() {
        if(scrollViewTop.contentOffset.x == self.view.frame.width * 3) {
            DispatchQueue.main.async(execute: {
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    self.scrollViewTop.contentOffset.x = 0
                    print(self.scrollViewTop.contentOffset.x)
                }, completion: nil)
            });
        }else {
            DispatchQueue.main.async(execute: {
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    self.scrollViewTop.contentOffset.x += self.view.frame.width
                    print(self.scrollViewTop.contentOffset.x)
                }, completion: nil)
            });
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewRecentContest {
            return 6
        }else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewRecentContest {
            let cellRecentContest = collectionView.dequeueReusableCell(withReuseIdentifier: "recentConstestCell", for: indexPath)
            
            let contestImage = cellRecentContest.viewWithTag(1) as! UIImageView
            let contestPayment = cellRecentContest.viewWithTag(2) as! UILabel
            let contestRecruit = cellRecentContest.viewWithTag(3) as! UILabel
            let contestPlace = cellRecentContest.viewWithTag(4) as! UILabel
            
            if(Contest_list.count > 0) {
                contestPayment.text = Contest_list[indexPath.row].Payment
                contestRecruit.text = Contest_list[indexPath.row].ContestDate
                contestPlace.text = Contest_list[indexPath.row].Place
                
                if(Contest_list[indexPath.row].Image != ".") {
                    let imageName = Contest_list[indexPath.row].Image
                    Alamofire.request("http://210.122.7.193:8080/Trophy_img/contest/\(imageName).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                        .responseImage { response in
                            //debugPrint(response)
                            //print(response.request)
                            //print(response.response)
                            //debugPrint(response.result)
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                // Store the commit date in to our cache
                                // Update the cell
                                DispatchQueue.main.async(execute: {
                                    contestImage.image = image
                                });
                            }
                    }
                }
            }
            return cellRecentContest
        }else {
            let cellMyRank = collectionView.dequeueReusableCell(withReuseIdentifier: "myRankCell", for: indexPath)
            
            let rankTeamEmblem = cellMyRank.viewWithTag(1) as! UIImageView
            let rankTeamName = cellMyRank.viewWithTag(2) as! UILabel
            let rankTeamRank = cellMyRank.viewWithTag(3) as! UILabel
            
            if(Rank_list.count > 0) {
                rankTeamName.text = Rank_list[indexPath.row].teamName
                rankTeamRank.text = Rank_list[indexPath.row].teamRank
                
                if(Rank_list[indexPath.row].teamEmblem != ".") {
                    let imageName = Rank_list[indexPath.row].teamEmblem
                    Alamofire.request("http://210.122.7.193:8080/Trophy_img/team/\(imageName).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                        .responseImage { response in
                            //debugPrint(response)
                            //print(response.request)
                            //print(response.response)
                            //debugPrint(response.result)
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                // Store the commit date in to our cache
                                // Update the cell
                                DispatchQueue.main.async(execute: {
                                    rankTeamEmblem.image = image
                                });
                            }
                    }
                }else {
                    rankTeamEmblem.image = UIImage(named: "ic_team")
                }
            }
            
            DispatchQueue.main.async(execute: {
                rankTeamEmblem.layer.cornerRadius = rankTeamEmblem.frame.size.width/2
                rankTeamEmblem.clipsToBounds = true
            })
            
            return cellMyRank
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(collectionView == self.collectionViewRecentContest) {
            
            return CGSize(width: CGFloat(view.frame.size.width/2), height: CGFloat(250))
        }else {
            
            return CGSize(width: CGFloat(view.frame.size.width/4), height: CGFloat(view.frame.size.width/4) + 20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == self.collectionViewRecentContest) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let contestDetailViewController = storyBoard.instantiateViewController(withIdentifier: "Contest_Detail_ViewController") as! Contest_Detail_ViewController
            contestDetailViewController.Contest_Pk = Contest_list[indexPath.row].Pk
            contestDetailViewController.Contest_Title = Contest_list[indexPath.row].Title
            contestDetailViewController.Contest_Image = Contest_list[indexPath.row].Image
            contestDetailViewController.Contest_CurrentNum = Contest_list[indexPath.row].CurrentNum
            contestDetailViewController.Contest_MaxNum = Contest_list[indexPath.row].MaxNum
            contestDetailViewController.Contest_Payment = Contest_list[indexPath.row].Payment
            contestDetailViewController.Contest_Host = Contest_list[indexPath.row].Host
            contestDetailViewController.Contest_Management = Contest_list[indexPath.row].Management
            contestDetailViewController.Contest_Support = Contest_list[indexPath.row].Support
            contestDetailViewController.Contest_ContestDate = Contest_list[indexPath.row].ContestDate
            contestDetailViewController.Contest_RecruitStartDate = Contest_list[indexPath.row].RecruitStartDate
            contestDetailViewController.Contest_RecruitFinishDate = Contest_list[indexPath.row].RecruitFinishDate
            contestDetailViewController.Contest_DetailInfo = Contest_list[indexPath.row].DetailInfo
            contestDetailViewController.Contest_Place = Contest_list[indexPath.row].Place
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            
            self.navigationController?.pushViewController(contestDetailViewController, animated: true)
            //self.present(contestDetailViewController, animated: true, completion: nil)
            //Contest_Detail_ViewController
        }else {
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func getRecentContest() {
        // 최근대회정보 가져오기
        let url:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/Contest_Customlist.jsp")!;
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        
                        self.Contest_Setting = Contest_Detail_Setting()
                        self.Contest_Setting.Pk = dict["_Pk"] as! String
                        self.Contest_Setting.Title = dict["_Title"] as! String
                        self.Contest_Setting.Image = dict["_Image"] as! String
                        self.Contest_Setting.CurrentNum = dict["_currentNum"] as! String
                        self.Contest_Setting.MaxNum = dict["_maxNum"] as! String
                        self.Contest_Setting.Payment = dict["_Payment"] as! String
                        self.Contest_Setting.Host = dict["_Host"] as! String
                        self.Contest_Setting.Management = dict["_Management"] as! String
                        self.Contest_Setting.Support = dict["_Support"] as! String
                        self.Contest_Setting.ContestDate = dict["_ContestDate"] as! String
                        self.Contest_Setting.RecruitStartDate = dict["_RecruitStartDate"] as! String
                        self.Contest_Setting.RecruitFinishDate = dict["_RecruitFinishDate"] as! String
                        self.Contest_Setting.DetailInfo = dict["_DetailInfo"] as! String
                        self.Contest_Setting.Place = dict["_Place"] as! String
                        
                        self.Contest_list.append(self.Contest_Setting)
                    }
                }
            }
            self.collectionViewRecentContest.reloadData()
        }
    }
    
    func getTeamRank() {
        // 팀 랭킹 가져오기
        let rankUrl:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/Main_Ranking.jsp?Data1=\(userPk)")!;
        Alamofire.request(rankUrl).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        
                        self.Rank_Setting = TeamRankSetting()
                        self.Rank_Setting.teamPk = dict["msg1"] as! String
                        self.Rank_Setting.teamEmblem = dict["msg2"] as! String
                        self.Rank_Setting.teamName = dict["msg3"] as! String
                        self.Rank_Setting.teamRank = String(dict["msg4"] as! Int)
                        
                        self.Rank_list.append(self.Rank_Setting)
                    }
                }
            }
            self.collectionViewMyRank.reloadData()
        }
    }
}
