//

//  ViewController.swift

//  slidetest1

//

//  Created by MD313-008 on 2017. 2. 7..

//  Copyright © 2017년 MD313-008. All rights reserved.

//



import UIKit


    @IBOutlet weak var open: UIBarButtonItem!
    var isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
    
    
    @IBOutlet weak var open: UIBarButtonItem!
    
    @IBOutlet var Contest_TableView: UITableView!
    var Contest_list:[Contest_Detail_Setting] = []
    var filteredData:[String] = []
    var Array = [[],[]]
    var Contest_Setting = Contest_Detail_Setting()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(isUserLoggedIn)
        if(!isUserLoggedIn) {
            NSUserDefaults.standardUserDefaults().setValue(".", forKey: "Pk")
        }
        
        open.target = self.revealViewController()
        open.action = Selector("revealToggle:")
        
        self.Contest_TableView.dataSource = self
        self.Contest_TableView.delegate = self
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part3/Contest_Customlist.jsp")!)
        let parameterString = ""
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
                    
                    self.Contest_Setting = Contest_Detail_Setting()
                    self.Contest_Setting.Pk = (row["_Pk"] as? String)!
                    self.Contest_Setting.Title = (row["_Title"] as? String)!
                    self.Contest_Setting.Image = (row["_Image"] as? String)!
                    self.Contest_Setting.CurrentNum = (row["_currentNum"] as? String)!
                    self.Contest_Setting.MaxNum = (row["_maxNum"] as? String)!
                    self.Contest_Setting.Payment = (row["_Payment"] as? String)!
                    self.Contest_Setting.Host = (row["_Host"] as? String)!
                    self.Contest_Setting.Management = (row["_Management"] as? String)!
                    self.Contest_Setting.Support = (row["_Support"] as? String)!
                    self.Contest_Setting.ContestDate = (row["_ContestDate"] as? String)!
                    self.Contest_Setting.RecruitStartDate = (row["_RecruitStartDate"] as? String)!
                    self.Contest_Setting.RecruitFinishDate = (row["_RecruitFinishDate"] as? String)!
                    self.Contest_Setting.DetailInfo = (row["_DetailInfo"] as? String)!
                    self.Contest_Setting.Place = (row["_Place"] as? String)!
                    
                    self.Contest_list.append(self.Contest_Setting)
                    
                }
                
                print(self.Contest_Setting.ContestDate)
                
            }catch{
                
                
                
            }
            
            dispatch_async(dispatch_get_main_queue()){
                
                self.Contest_TableView.reloadData()
                
            }
            
        }
        
        task.resume()
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return self.Contest_list.count

    }
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContestCell", forIndexPath: indexPath)
        let Contest_Title = cell.viewWithTag(2) as! UILabel
        let Contest_Date = cell.viewWithTag(3) as! UILabel
        let Contest_Place = cell.viewWithTag(4) as! UILabel
    
        // Configure the cell...
        Contest_Title.text = Contest_list[indexPath.row].Title
        Contest_Date.text = Contest_list[indexPath.row].ContestDate
        Contest_Place.text = Contest_list[indexPath.row].Place
        
        let videoString = "http://210.122.7.193:8080/Trophy_img/contest/"+self.Contest_list[indexPath.row].Image+".jpg"
        let videoThumbnailUrl = NSURL(string: videoString)
    if videoThumbnailUrl != nil{
            
        let request = NSURLRequest(URL:videoThumbnailUrl!)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
        let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.image = UIImage(data: data!)
        })
        dataTask.resume()
    }
    return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let Contest_Detail_View = segue.destinationViewController as! Contest_Detail_ViewController
        let myIndexPath = self.Contest_TableView.indexPathForSelectedRow!
        let row = myIndexPath.row
        
        Contest_Detail_View.Contest_Pk = Contest_list[row].Pk
        Contest_Detail_View.Contest_Title = Contest_list[row].Title
        Contest_Detail_View.Contest_Image = Contest_list[row].Image
        Contest_Detail_View.Contest_CurrentNum = Contest_list[row].CurrentNum
        Contest_Detail_View.Contest_MaxNum = Contest_list[row].MaxNum
        Contest_Detail_View.Contest_Payment = Contest_list[row].Payment
        Contest_Detail_View.Contest_Host = Contest_list[row].Host
        Contest_Detail_View.Contest_Management = Contest_list[row].Management
        Contest_Detail_View.Contest_Support = Contest_list[row].Support
        Contest_Detail_View.Contest_ContestDate = Contest_list[row].ContestDate
        Contest_Detail_View.Contest_RecruitStartDate = Contest_list[row].RecruitStartDate
        Contest_Detail_View.Contest_RecruitFinishDate = Contest_list[row].RecruitFinishDate
        Contest_Detail_View.Contest_DetailInfo = Contest_list[row].DetailInfo
        Contest_Detail_View.Contest_Place = Contest_list[row].Place
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    
    }
    
    
    
}

