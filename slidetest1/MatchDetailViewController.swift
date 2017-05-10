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

    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var matchTitle: UITextField!
    @IBOutlet weak var matchAddress: UITextField!
    @IBOutlet weak var matchDate: UITextField!
    
    var arrRes = [[String:AnyObject]]()
    
    var matchPk:String = ""
    var matchSetting = MatchSetting()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request("http://210.122.7.193:8080/Trophy_part1/Match_Focus.jsp").responseJSON { (responseData) -> Void in
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
                        self.matchSetting.matchPlace = dict["msg5"] as! String
                        self.matchSetting.matchTime = dict["msg6"] as! String
                        self.matchSetting.matchStatus = dict["msg7"] as! String
                        
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
