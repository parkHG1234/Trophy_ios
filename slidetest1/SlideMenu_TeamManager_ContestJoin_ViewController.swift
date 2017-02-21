//
//  SlideMenu_TeamManager_ContestJoin_ViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 15..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class SlideMenu_TeamManager_ContestJoin_ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var ContestJoin_TableView: UITableView!
    var TeamName : String = "AldongTeam"

    var Http_ContestPk = [String]()
    var Http_ContestImg = [String]()
    var Http_ContestTitle = [String]()
    var Http_ContestStatus = [String]()
    var Http_AcountName = [String]()
    var Http_AcountNumber = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        ContestJoin_TableView.delegate = self
        ContestJoin_TableView.dataSource = self
        let request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part1/TeamManager_ContestJoin.jsp")!)
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
                    self.Http_ContestPk.append((row["msg1"] as? String)!)
                    self.Http_ContestImg.append((row["msg2"] as? String)!)
                    self.Http_ContestTitle.append((row["msg3"] as? String)!)
                    self.Http_ContestStatus.append((row["msg4"] as? String)!)
                    self.Http_AcountName.append((row["msg5"] as? String)!)
                    self.Http_AcountNumber.append((row["msg6"] as? String)!)
                }
            }catch{
                
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.ContestJoin_TableView.reloadData()
            }
        }
        task.resume()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Http_ContestPk.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContestJoinCell", forIndexPath: indexPath)

//        let ContestImage1 = cell.viewWithTag(1) as! UIImageView
        let ContestTitle = cell.viewWithTag(2) as! UILabel
        let ContestStatus = cell.viewWithTag(3) as! UILabel
        
//        let url = NSURL(string:"http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg")
//        let data = NSData(contentsOfURL:url!)
//        ContestImage1.image = UIImage(data:data!)
        
        ContestTitle.text = self.Http_ContestTitle[indexPath.row]
        ContestStatus.text = self.Http_ContestStatus[indexPath.row]
        
        let ContestUrlString = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
        let ContestUrl = NSURL(string: ContestUrlString)
        if ContestUrl != nil {
            let request = NSURLRequest(URL: ContestUrl!)
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let imageView = cell.viewWithTag(4) as! UIImageView
                    imageView.image = UIImage(data: data!)
                })
            })
            
            dataTask.resume()
        }
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ContestJoin_Focus_Segue" {
            let SlideMenu_TeamManager_ContestJoin_Focus = segue.destinationViewController as! SlideMenu_TeamManager_ContestJoin_Focus_ViewController
            let myIndexPath = self.ContestJoin_TableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            SlideMenu_TeamManager_ContestJoin_Focus.TeamName = TeamName
            SlideMenu_TeamManager_ContestJoin_Focus.Contest_Pk = Http_ContestPk[row]
            SlideMenu_TeamManager_ContestJoin_Focus.Contest_Image = Http_ContestImg[row]
            SlideMenu_TeamManager_ContestJoin_Focus.Contest_Title = Http_ContestTitle[row]
            SlideMenu_TeamManager_ContestJoin_Focus.Contest_Status = Http_ContestStatus[row]
            SlideMenu_TeamManager_ContestJoin_Focus.AcountName = Http_AcountName[row]
            SlideMenu_TeamManager_ContestJoin_Focus.AcountNumber = Http_AcountNumber[row]
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Back_Button_Action(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
