//
//  SlideMenu_TeamManager_PlayerManager_ViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 16..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class SlideMenu_TeamManager_PlayerManager_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var centerPopUpConstraint: NSLayoutConstraint!
    @IBOutlet weak var Joiner_TableView: UITableView!
    @IBOutlet weak var Player_TableView: UITableView!

    var TeamName : String = "AldongTeam"
    var HttpStatue: String = "start"
    
    var Http_Joiner_Profile = [String]()
    var Http_Joiner_Name = [String]()
    var Http_Joiner_Pk = [String]()
    
    var Http_Player_Profile = [String]()
    var Http_Player_Name = [String]()
    var Http_Player_Pk = [String]()
    
    var Player_Count : Int = 0
    var Player_ExtraCount : Int = 0
    var Joiner_Count : Int = 0
    var Joiner_ExtraCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Joiner_TableView.dataSource = self
        Joiner_TableView.delegate = self
        Player_TableView.dataSource = self
        Player_TableView.delegate = self
        
        //////신청자 http//////////////////////
        let request1 = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part1/TeamManager_Joiner.jsp")!)
        let parameterString1 = "Data1="+TeamName
        HttpStatue = "start"
        request1.HTTPMethod = "POST"
        request1.HTTPBody = parameterString1.dataUsingEncoding(NSUTF8StringEncoding)
        let task1 = NSURLSession.sharedSession().dataTaskWithRequest(request1){
            data, response, error in
            
            if error != nil {
                return
            }
            print("response = \(response)")
            
            let responseString:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print("responseString = \(responseString)")
            do{
                let apiDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                let list = apiDictionary["List"] as! NSArray
                for row in list{
                    self.Http_Joiner_Profile.append((row["msg1"] as? String)!)
                    self.Http_Joiner_Name.append((row["msg2"] as? String)!)
                    self.Http_Joiner_Pk.append((row["msg3"] as? String)!)
                    self.Joiner_Count++
                    dispatch_async(dispatch_get_main_queue()) {
                        self.Joiner_TableView.reloadData()
                    }
                }
            }catch{
                
            }
            print(self.Joiner_Count)
            if self.Joiner_Count%3 == 1 {
                self.Http_Joiner_Profile.append(".")
                self.Http_Joiner_Name.append(".")
                self.Http_Joiner_Pk.append(".")
                self.Http_Joiner_Profile.append(".")
                self.Http_Joiner_Name.append(".")
                self.Http_Joiner_Pk.append(".")
                
            }
            else if self.Joiner_Count%3 == 2 {
                self.Http_Joiner_Profile.append(".")
                self.Http_Joiner_Name.append(".")
                self.Http_Joiner_Pk.append(".")
            }
        }
        task1.resume()
//////////////////팀원 http
        let request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part1/TeamManager_Player.jsp")!)
        let parameterString = "Data1="+TeamName
        request.HTTPMethod = "POST"
        request.HTTPBody = parameterString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil {
                return
            }
            print("response = \(response)")
            
            let responseString:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print("responseString = \(responseString)")
            do{
                let apiDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                let list = apiDictionary["List"] as! NSArray
                for row in list{
                    self.Http_Player_Profile.append((row["msg1"] as? String)!)
                    self.Http_Player_Name.append((row["msg2"] as? String)!)
                    self.Http_Player_Pk.append((row["msg3"] as? String)!)
                    self.Player_Count++
                    dispatch_async(dispatch_get_main_queue()) {
                        self.Player_TableView.reloadData()
                    }
                }
            }catch{
                
            }
            print(self.Player_Count)
            if self.Player_Count%3 == 1 {
                self.Http_Player_Profile.append(".")
                self.Http_Player_Name.append(".")
                self.Http_Player_Pk.append(".")
                self.Http_Player_Profile.append(".")
                self.Http_Player_Name.append(".")
                self.Http_Player_Pk.append(".")

            }
            else if self.Player_Count%3 == 2 {
                self.Http_Player_Profile.append(".")
                self.Http_Player_Name.append(".")
                self.Http_Player_Pk.append(".")
            }
            self.HttpStatue = "end"

        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            Joiner_ExtraCount = Joiner_Count%3
            var RowCount : Int = Joiner_Count/3
            if Joiner_Count == 0 {
                RowCount = 0
            }
            else if Joiner_Count == 1 {
                RowCount = 1
            }
            else if Joiner_Count == 2 {
                RowCount = 1
            }
            else {
                if Joiner_ExtraCount == 1 {
                    RowCount++
                }
                else if Joiner_ExtraCount == 2{
                    RowCount++
                }
                else{
                    
                }
            }
            return RowCount
        }
        else {
            Player_ExtraCount = Player_Count%3
            var RowCount : Int = Player_Count/3
            if Player_ExtraCount == 1 {
                RowCount++
            }
            else if Player_ExtraCount == 2{
                RowCount++
            }
            else{
                
            }
            return RowCount
        }
        // #warning Incomplete implementation, return the number of rows
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        if HttpStatue == "end"{
            if tableView.tag == 1{
                cell = tableView.dequeueReusableCellWithIdentifier("PlayerManager_Joiner_3PersonCell", forIndexPath: indexPath)
                let Joiner1Image = cell.viewWithTag(1) as! UIImageView
                let Joiner2Image = cell.viewWithTag(2) as! UIImageView
                let Joiner3Image = cell.viewWithTag(3) as! UIImageView
                let Joiner1Label = cell.viewWithTag(4) as! UILabel
                let Joiner2Label = cell.viewWithTag(5) as! UILabel
                let Joiner3Label = cell.viewWithTag(6) as! UILabel
                
                Joiner1Label.hidden = false
                Joiner2Label.hidden = false
                Joiner3Label.hidden = false
                
                let ContestUrlString1 = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
                let ContestUrl1 = NSURL(string: ContestUrlString1)
                if ContestUrl1 != nil {
                    let request = NSURLRequest(URL: ContestUrl1!)
                    let session = NSURLSession.sharedSession()
                    let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            Joiner1Image.image = UIImage(data: data!)
                        })
                    })
                    
                    dataTask.resume()
                }
                let ContestUrlString2 = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
                let ContestUrl2 = NSURL(string: ContestUrlString2)
                if ContestUrl2 != nil {
                    let request = NSURLRequest(URL: ContestUrl2!)
                    let session = NSURLSession.sharedSession()
                    let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //                            Player2Image.image = UIImage(data: data!)
                        })
                    })
                    
                    dataTask.resume()
                }
                let ContestUrlString3 = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
                let ContestUrl3 = NSURL(string: ContestUrlString3)
                if ContestUrl3 != nil {
                    let request = NSURLRequest(URL: ContestUrl3!)
                    let session = NSURLSession.sharedSession()
                    let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //                            Player3Image.image = UIImage(data: data!)
                        })
                    })
                    
                    dataTask.resume()
                }
                if self.Http_Joiner_Name[indexPath.row*3+1] == "."{
                    Joiner1Label.text = self.Http_Joiner_Name[indexPath.row*3]
                    Joiner1Label.hidden = false
                    Joiner2Label.hidden = true
                    Joiner3Label.hidden = true
                }
                if self.Http_Joiner_Name[indexPath.row*3+2] == "."{
                    Joiner1Label.text = self.Http_Joiner_Name[indexPath.row*3]
                    Joiner2Label.text = self.Http_Joiner_Name[indexPath.row*3+1]
                    Joiner1Label.hidden = false
                    Joiner2Label.hidden = false
                    Joiner3Label.hidden = true
                }
                else{
                    Joiner1Label.text = self.Http_Player_Name[indexPath.row*3]
                    Joiner2Label.text = self.Http_Player_Name[indexPath.row*3+1]
                    Joiner3Label.text = self.Http_Player_Name[indexPath.row*3+2]
                    Joiner1Label.hidden = false
                    Joiner2Label.hidden = false
                    Joiner3Label.hidden = false
                }
                return cell
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("PlayerManager_Player_3PersonCell", forIndexPath: indexPath)
                let Player1Image = cell.viewWithTag(1) as! UIImageView
                let Player2Image = cell.viewWithTag(2) as! UIImageView
                let Player3Image = cell.viewWithTag(3) as! UIImageView
                let Player1Label = cell.viewWithTag(4) as! UILabel
                let Player2Label = cell.viewWithTag(5) as! UILabel
                let Player3Label = cell.viewWithTag(6) as! UILabel
                
                Player1Label.hidden = false
                Player2Label.hidden = false
                Player3Label.hidden = false
                
                
                Player1Image.userInteractionEnabled = true
                Player1Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "Player_Image1_ImageView_Action:"))
                
                let ContestUrlString1 = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
                let ContestUrl1 = NSURL(string: ContestUrlString1)
                if ContestUrl1 != nil {
                    let request = NSURLRequest(URL: ContestUrl1!)
                    let session = NSURLSession.sharedSession()
                    let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            Player1Image.image = UIImage(data: data!)
                        })
                    })
                    
                    dataTask.resume()
                }
                let ContestUrlString2 = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
                let ContestUrl2 = NSURL(string: ContestUrlString2)
                if ContestUrl2 != nil {
                    let request = NSURLRequest(URL: ContestUrl2!)
                    let session = NSURLSession.sharedSession()
                    let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //                            Player2Image.image = UIImage(data: data!)
                        })
                    })
                    
                    dataTask.resume()
                }
                let ContestUrlString3 = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
                let ContestUrl3 = NSURL(string: ContestUrlString3)
                if ContestUrl3 != nil {
                    let request = NSURLRequest(URL: ContestUrl3!)
                    let session = NSURLSession.sharedSession()
                    let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //                            Player3Image.image = UIImage(data: data!)
                        })
                    })
                    
                    dataTask.resume()
                }
                if self.Http_Player_Name[indexPath.row*3+1] == "."{
                    Player1Label.text = self.Http_Player_Name[indexPath.row*3]
                    Player1Label.hidden = false
                    Player2Label.hidden = true
                    Player3Label.hidden = true
                }
                if self.Http_Player_Name[indexPath.row*3+2] == "."{
                    Player1Label.text = self.Http_Player_Name[indexPath.row*3]
                    Player2Label.text = self.Http_Player_Name[indexPath.row*3+1]
                    Player1Label.hidden = false
                    Player2Label.hidden = false
                    Player3Label.hidden = true
                }
                else{
                    Player1Label.text = self.Http_Player_Name[indexPath.row*3]
                    Player2Label.text = self.Http_Player_Name[indexPath.row*3+1]
                    Player3Label.text = self.Http_Player_Name[indexPath.row*3+2]
                    Player1Label.hidden = false
                    Player2Label.hidden = false
                    Player3Label.hidden = false
                }
                return cell
            }
        }
        else{
          
            if tableView.tag == 1{
                 cell = tableView.dequeueReusableCellWithIdentifier("PlayerManager_Joiner_3PersonCell", forIndexPath: indexPath)
                let Joiner1Image = cell.viewWithTag(1) as! UIImageView
                let Joiner2Image = cell.viewWithTag(2) as! UIImageView
                let Joiner3Image = cell.viewWithTag(3) as! UIImageView
                let Joiner1Label = cell.viewWithTag(4) as! UILabel
                let Joiner2Label = cell.viewWithTag(5) as! UILabel
                let Joiner3Label = cell.viewWithTag(6) as! UILabel
                Joiner1Label.text = " "
                Joiner2Label.text = " "
                Joiner3Label.text = " "
            }
            else{
                cell = tableView.dequeueReusableCellWithIdentifier("PlayerManager_Player_3PersonCell", forIndexPath: indexPath)
                let Player1Image = cell.viewWithTag(1) as! UIImageView
                let Player2Image = cell.viewWithTag(2) as! UIImageView
                let Player3Image = cell.viewWithTag(3) as! UIImageView
                let Player1Label = cell.viewWithTag(4) as! UILabel
                let Player2Label = cell.viewWithTag(5) as! UILabel
                let Player3Label = cell.viewWithTag(6) as! UILabel
                Player1Label.text = " "
                Player2Label.text = " "
                Player3Label.text = " "
            }
            return cell
        }
    }
    @IBAction internal func Close_PopUp(sender: AnyObject){
        print("123123")
    }
    func Player_Image1_ImageView_Action(sender: UITapGestureRecognizer){
        if(sender.state == .Ended){
            centerPopUpConstraint.constant = 0
            UIView.animateWithDuration(0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
