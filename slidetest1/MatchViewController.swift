//
//  MatchViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 23..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON

class MatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var open: UIBarButtonItem!
    @IBOutlet weak var matchTableView: UITableView!
    
    var arrRes = [[String:AnyObject]]()
    var matchSetting = MatchSetting()
    var matchList:[MatchSetting] = []
    
    var isMain:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        matchTableView.dataSource = self
        matchTableView.delegate = self

        if(isMain) {
            self.navigationItem.leftBarButtonItem = nil
        }else {
            self.navigationItem.leftBarButtonItem = open
        }
        
        
        if self.revealViewController() != nil {
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        
        matchList = []
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part1/Match.jsp").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        
                        self.matchSetting = MatchSetting()
                        self.matchSetting.matchPk = dict["msg1"] as! String
                        self.matchSetting.teamEmblem = dict["msg2"] as! String
                        self.matchSetting.teamName = dict["msg3"] as! String
                        self.matchSetting.matchTitle = dict["msg4"] as! String
                        self.matchSetting.matchPlace = dict["msg6"] as! String
                        self.matchSetting.matchStartTime = dict["msg5"] as! String
                        self.matchSetting.matchStatus = dict["msg7"] as! String
                        
                        self.matchList.append(self.matchSetting)
                    }
                    self.matchTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath)
        
        let teamEmblemImageView = cell.viewWithTag(1) as! UIImageView
        let teamNameLabel = cell.viewWithTag(2) as! UILabel
        let matchTitleLabel = cell.viewWithTag(3) as! UILabel
        let matchPlace = cell.viewWithTag(4) as! UILabel
        let matchTime = cell.viewWithTag(5) as! UILabel
        
        
        teamNameLabel.text = matchList[indexPath.row].teamName
        matchTitleLabel.text = matchList[indexPath.row].matchTitle
        matchPlace.text = matchList[indexPath.row].matchPlace
        matchTime.text = matchList[indexPath.row].matchStartTime
        
        if(matchList[indexPath.row].teamEmblem != ".") {
            let url = "http://210.122.7.193:8080/Trophy_img/team/\(matchList[indexPath.row].teamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            Alamofire.request(url!).responseImage { response in
                if let image = response.result.value {
                    debugPrint(response.result)
                    DispatchQueue.main.async(execute: {
                        let imageView = cell.viewWithTag(1) as! UIImageView
                        imageView.layer.cornerRadius = imageView.frame.size.width/2
                        imageView.clipsToBounds = true
                        imageView.image = image
                        
                    });
                }
            }
        }else {
            teamEmblemImageView.layer.cornerRadius = teamEmblemImageView.frame.size.width/2
            teamEmblemImageView.clipsToBounds = true
            teamEmblemImageView.image = UIImage(named: "ic_team")
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goDetail") {
            let matchDetailViewController = segue.destination as! MatchDetailViewController
            let myIndexPath = self.matchTableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            
            matchDetailViewController.matchPk = self.matchList[row].matchPk
            print("aaa : \(self.matchList[row].matchPk)")
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
