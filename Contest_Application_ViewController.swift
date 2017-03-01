//
//  Contest_Application_ViewController.swift
//  slidetest1
//
//  Created by MD313-007 on 2017. 2. 17..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class Contest_Application_ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    var User_Pk:String = ""
    var Contest_Pk:String = ""
    var MyTeamName:String = ""
    var succed:String=""
    
    var Select_List:[String] = []
    var Insert_List:[String] = []
    var Application_Setting = Contest_Application_Setting()
    var Application_list:[Contest_Application_Setting] = []
    var Member_Setting = Contest_Member_Setting()
    var Member_list:[Contest_Member_Setting] = []
    
    
    @IBOutlet var Contest_Member_TableView: UITableView!
    @IBOutlet var Contest_Application_TeamName: UILabel!
    @IBOutlet var Contest_Application_TeamLeader: UILabel!
    @IBOutlet var Contest_Application_TeamPhone: UILabel!
    @IBOutlet var Contest_Application_Person: UILabel!
    override func viewDidLoad() {
        
        
        self.Contest_Member_TableView.dataSource = self
        self.Contest_Member_TableView.delegate = self
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part1/Contest_Detail_Form_Profile.jsp")!)
        let parameterString = "Data1=\(self.User_Pk)";
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
                    self.Application_Setting = Contest_Application_Setting()
                    self.Application_Setting.Name = (row["msg1"] as? String)!
                    self.Application_Setting.Team = (row["msg2"] as? String)!
                    self.Application_Setting.Phone = (row["msg3"] as? String)!
                    self.Application_list.append(self.Application_Setting)
                }
                
            }catch{
                
            }
            dispatch_async(dispatch_get_main_queue()){
                self.Contest_Application_TeamName.text = self.Application_Setting.Name
                self.Contest_Application_TeamLeader.text = self.Application_Setting.Team
                self.Contest_Application_TeamPhone.text = self.Application_Setting.Phone
            }
        }
        
        task.resume()
        
        let Member_request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part1/Contest_Detail_Form_Player.jsp")!)
        let Member_parameterString = "Data1=\(self.MyTeamName)";
        Member_request.HTTPMethod = "POST"
        Member_request.HTTPBody = Member_parameterString.dataUsingEncoding(NSUTF8StringEncoding)
        let Member_task = NSURLSession.sharedSession().dataTaskWithRequest(Member_request){
            data, response, error in
            if error != nil {
                return
            }
            print("response = \(response)")
            let Member_responseString:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print("responseString = \(Member_responseString)")
            do{
                let apiDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                let list = apiDictionary["List"] as! NSArray
                for row in list{
                    self.Member_Setting = Contest_Member_Setting()
                    self.Member_Setting.Name = (row["msg1"] as? String)!
                    self.Member_Setting.Birth = (row["msg2"] as? String)!
                    self.Member_Setting.Profile = (row["msg3"] as? String)!
                    self.Member_Setting.Pk = (row["msg4"] as? String)!
                    self.Member_Setting.Duty = (row["msg5"] as? String)!
                    self.Member_list.append(self.Member_Setting)
                }
                
            }catch{
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.Contest_Application_Person.text = String(self.Member_list.count)+"명 참가"
                self.Contest_Member_TableView.reloadData()
            }
        }
        Member_task.resume()
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return self.Member_list.count
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Select_List.append(String(Member_list[indexPath.row].Pk))
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemberCell", forIndexPath: indexPath)
        let Member_Duty = cell.viewWithTag(5) as! UILabel
        let Member_Name = cell.viewWithTag(6) as! UILabel
        let Member_Birth = cell.viewWithTag(7) as! UILabel
        
        // Configure the cell...        
        Member_Duty.text = Member_list[indexPath.row].Duty
        Member_Name.text = Member_list[indexPath.row].Name
        Member_Birth.text = Member_list[indexPath.row].Birth
        
        if self.Member_list[indexPath.row].Profile == "."{
                    let imageView = cell.viewWithTag(8) as! UIImageView
                    imageView.image = UIImage(named: "image")
        }else{
            let videoString = "http://210.122.7.193:8080/Trophy_img/Profile/"+self.Member_list[indexPath.row].Profile+".jpg"
            let videoThumbnailUrl = NSURL(string: videoString)
            if videoThumbnailUrl != nil{
                
                let Member_request = NSURLRequest(URL:videoThumbnailUrl!)
                let session = NSURLSession.sharedSession()
                let dataTask = session.dataTaskWithRequest(Member_request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                    
                    let imageView = cell.viewWithTag(8) as! UIImageView
                    imageView.image = UIImage(data: data!)
                })
                dataTask.resume()
        }
        
        }
        return cell
    }
    
    
    @IBAction func Contest_Application_Input(sender: AnyObject) {
        var cnt = 0
        if(Select_List.isEmpty){
            
        }else{
            for (var i=0;i<Select_List.count;i++){
                cnt = 0
                for (var j=0;j<Select_List.count;j++){
                    if(Select_List[i]==Select_List[j]){
                        cnt++
                    }
                }
                if(cnt%2==1){
                    Insert_List.append(Select_List[Int(i)])
                    for (var k=0;k<Select_List.count;k++){
                        if(Select_List[i]==Select_List[k]){
                            Select_List[k].removeAll()
                        }
                    }
                }
            }
        }
        
        if(!Select_List.isEmpty){
        
        let Insert_request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part1/Contest_Detail_Form_Join.jsp")!)
        for (var i=0;i<Insert_List.count;i++){
            let Insert_parameterString = "Data1=\(self.Insert_List[i])"+"&"+"Data2=\(self.Contest_Pk)";
            print("====="+Insert_parameterString)
            Insert_request.HTTPMethod = "POST"
            Insert_request.HTTPBody = Insert_parameterString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let Insert_Team_task = NSURLSession.sharedSession().dataTaskWithRequest(Insert_request){
            data, response, error in
            if error != nil {
                return
            }
            print("response = \(response)")
            let Member_responseString:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print("responseString = \(Member_responseString)")
            do{
                let apiDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                let list = apiDictionary["List"] as! NSArray
                for row in list{
                    self.succed = (row["msg1"] as? String)!
                }
            }catch{
            }
            
        }
        Insert_Team_task.resume()
        }
        
        
        
        let Join_Team_request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part1/Contest_Detail_Form_Join_Team.jsp")!)
            let Join_Team_parameterString = "Data1=\(self.Contest_Pk)"+"&"+"Data2=\(self.MyTeamName)";
        
            Join_Team_request.HTTPMethod = "POST"
            Join_Team_request.HTTPBody = Join_Team_parameterString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let Join_Team_task = NSURLSession.sharedSession().dataTaskWithRequest(Join_Team_request){
            data, response, error in
            if error != nil {
                return
            }
            print("response = \(response)")
            let Member_responseString:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print("responseString = \(Member_responseString)")
            do{
                let apiDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                let list = apiDictionary["List"] as! NSArray
                for row in list{
                    self.succed = (row["msg1"] as? String)!
                }
            }catch{
            }
            
        }
        Join_Team_task.resume()
        
        self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
