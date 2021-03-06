//
//  CourtAddressDetailViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 5. 1..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class CourtAddressDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var courtTableView: UITableView!
    
    var addressDo:String = ""
    var addressSi:[String] = []
    
    var isUserLoggedIn:Bool = false
    var userPk:String = ""
    
    var isMain:Bool = false
    
    var arrRes = [[String:AnyObject]]()
    var courtSetting = CourtSetting()
    var courtList:[CourtSetting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        courtTableView.dataSource = self
        courtTableView.delegate = self
        
        getData()
    }
    
    func getData() {
        let count = addressSi.count
        for i in 0 ..< count {
            
            print("도 : \(addressDo) 시 : \(addressSi[i])")
            
            let nowDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy / MM / dd:::HH : mm"
            let nowDateString = dateFormatter.string(from: nowDate)
            
            var url = "".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            if(isMain) {
                url = "http://210.122.7.193:8080/Trophy_part3/CourtRecommend.jsp?Data1=\(addressDo)&Data2=.&Data3=\(nowDateString)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            }else {
                url = "http://210.122.7.193:8080/Trophy_part3/Court.jsp?Data1=\(addressDo)&Data2=\(addressSi[i])".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            }
            
            Alamofire.request(url!).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    
                    if self.arrRes.count > 0 {
                        for i in 0 ..< self.arrRes.count {
                            var dict = self.arrRes[i]
                            
                            self.courtSetting = CourtSetting()
                            self.courtSetting.courtName = dict["msg1"] as! String
                            self.courtSetting.courtAddressDo = dict["msg2"] as! String
                            self.courtSetting.courtAddressSi = dict["msg3"] as! String
                            self.courtSetting.courtPk = dict["msg4"] as! String
                            self.courtSetting.courtImage = dict["msg5"] as! String
                            
                            self.courtList.append(self.courtSetting)
                            print("카운트 : \(self.courtList.count)")
                        }
                        self.courtTableView.reloadData()
                    }
                }
            }
        }
        self.courtTableView.reloadData()
    }
    
    //네비게이션 아이템
    @IBAction func addButtonTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let courtApplicationButton = UIAlertAction(title: "코트 추가 요청", style: UIAlertActionStyle.destructive, handler: { (applicationSeleted) -> Void in
            
            self.isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
            
            if(self.isUserLoggedIn) {
                
            }else {
                let myAlert = UIAlertController(title: "오늘의농구", message: "로그인이 필요합니다", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
            }
        })
        actionSheet.addAction(courtApplicationButton)
        
        let cancelButton = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: { (cancelSeleted) -> Void in
        })
        
        actionSheet.addAction(cancelButton)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courtList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        cell = tableView.dequeueReusableCell(withIdentifier: "courtCell2", for: indexPath)
        
        let courtImage = cell?.viewWithTag(1) as! UIImageView
        let courtName = cell?.viewWithTag(2) as! UILabel
        let courtAddressDo = cell?.viewWithTag(3) as! UILabel
        let courtAddressSi = cell?.viewWithTag(4) as! UILabel
        
        courtName.text = courtList[indexPath.row].courtName
        courtAddressDo.text = courtList[indexPath.row].courtAddressDo
        courtAddressSi.text = courtList[indexPath.row].courtAddressSi
        
        if(courtList[indexPath.row].courtImage != ".") {
            Alamofire.request("http://210.122.7.193:8080/Trophy_img/court/\(courtList[indexPath.row].courtImage).jpg")
                .responseImage { response in
                    if let image = response.result.value {
                        DispatchQueue.main.async(execute: {
                            courtImage.image = image
                        });
                    }
            }
        }else {
            courtImage.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 55/255, alpha: 1)
            courtImage.image = nil
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goDetail") {
            let courtDetailViewController = segue.destination as! CourtDetailViewController
            let myIndexPath = self.courtTableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            
            courtDetailViewController.courtPk = courtList[row].courtPk
            courtDetailViewController.navigationItem.title = courtList[row].courtName
            
            UserDefaults.standard.set(courtList[row].courtPk, forKey: "courtPk")
            UserDefaults.standard.synchronize()
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
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
