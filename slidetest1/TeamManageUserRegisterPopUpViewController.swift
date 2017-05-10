//
//  TeamManageUserRegisterPopUpViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 3. 29..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TeamManageUserRegisterPopUpViewController: UIViewController {

    
    @IBOutlet weak var teamUserNameLabel: UILabel!
    @IBOutlet weak var teamUserAgeLabel: UILabel!
    @IBOutlet weak var teamUserSexLabel: UILabel!
    @IBOutlet weak var teamUserAddressDoLabel: UILabel!
    @IBOutlet weak var teamUserAddressSiLabel: UILabel!
    
    var teamPk:String = ""
    
    var teamUserPk:String = ""
    var teamUserName:String = ""
    var teamUserAge:String = ""
    var teamUserSex:String = ""
    var teamUserAddressDo:String = ""
    var teamUserAddressSi:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    
        teamUserNameLabel.text = teamUserName
        teamUserAgeLabel.text = teamUserAge
        teamUserSexLabel.text = teamUserSex
        teamUserAddressDoLabel.text = teamUserAddressDo
        teamUserAddressSiLabel.text = teamUserAddressSi
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
        super.viewDidAppear(false)
    }
    
    @IBAction func commitButtonTapped(_ sender: Any) {
        let url = "http://210.122.7.193:8080/Trophy_part3/TeamManageCommitUser.jsp?Data1=\(teamUserPk)&Data2=\(teamPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in}
        self.view.removeFromSuperview()
        super.viewDidAppear(false)
    }
    
    @IBAction func rejcetButtonTapped(_ sender: Any) {
        let url = "http://210.122.7.193:8080/Trophy_part3/TeamManageRejectUser.jsp?Data1=\(teamUserPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in}
        self.view.removeFromSuperview()
        super.viewDidAppear(false)
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
