//
//  TeamManageUserPopUpViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 3. 22..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class TeamManageUserPopUpViewController: UIViewController {

    @IBOutlet weak var teamUserNameLabel: UILabel!
    @IBOutlet weak var teamUserAgeLabel: UILabel!
    @IBOutlet weak var teamUserSexLabel: UILabel!
    @IBOutlet weak var teamUserAddressDoLabel: UILabel!
    @IBOutlet weak var teamUserAddressSiLabel: UILabel!
    @IBOutlet weak var teamUserPhoneLabel: UILabel!
    
    var teamPk:String = ""
    
    var teamUserPk:String = ""
    var teamUserName:String = ""
    var teamUserAge:String = ""
    var teamUserSex:String = ""
    var teamUserAddressDo:String = ""
    var teamUserAddressSi:String = ""
    var teamUserPhone:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        teamUserNameLabel.text = teamUserName
        teamUserAgeLabel.text = teamUserAge
        teamUserSexLabel.text = teamUserSex
        teamUserAddressDoLabel.text = teamUserAddressDo
        teamUserAddressSiLabel.text = teamUserAddressSi
        teamUserPhoneLabel.text = teamUserPhone
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    @IBAction func callButtonTapped(_ sender: Any) {
        let url = URL(string: "tel://\(teamUserPhone)")!
        UIApplication.shared.openURL(url)
    }
    @IBAction func delegateButtonTapped(_ sender: Any) {
    }
    @IBAction func removeButtonTapped(_ sender: Any) {
        let url = "http://210.122.7.193:8080/Trophy_part3/TeamManageRejectUser.jsp?Data1=\(teamUserPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in}
        self.view.removeFromSuperview()
        super.viewDidAppear(false)
    }

    
}
