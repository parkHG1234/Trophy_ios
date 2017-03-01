//
//  SlideMenu_TeamSearch1_ViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 26..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class SlideMenu_TeamSearch1_ViewController: UIViewController,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var TeamSearch_Table: UITableView!
    var tableData = [String]()
    var filteredData:[String] = []
    var resultSearchController:UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TeamSearch_Table.delegate = self
        TeamSearch_Table.dataSource = self
        //        for(var i=0;i<6;i++){
        //            self.tableData.insert("123", atIndex: i)
        //        }
        //http 통신
        let request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part1/TeamSearch.jsp")!)
        
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
                    self.tableData.append((row["msg1"] as? String)!)
                }
                print(self.tableData[2])
            }catch{
                
            }
            dispatch_async(dispatch_get_main_queue()){
                self.TeamSearch_Table.reloadData()
            }
        }
        task.resume()
        //http 통신 파싱
        
        //검색어 구현
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = false
        
        let newRed = CGFloat(233)/255
        let newGreen = CGFloat(56)/255
        let newBlue = CGFloat(69)/255
        
        resultSearchController.searchBar.backgroundColor = UIColor.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        resultSearchController.searchBar.barTintColor = UIColor.init(red: newRed, green: newGreen, blue: newBlue, alpha: 0)
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        resultSearchController.searchBar.sizeToFit()
        
        self.TeamSearch_Table.tableHeaderView = resultSearchController.searchBar
        //self.TeamSearch_Searchbar = resultSearchController.searchBar

        //////
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        if resultSearchController.active {
            return filteredData.count
        }
        else{
            return tableData.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        let label = cell.viewWithTag(2) as! UILabel
        // Configure the cell...
        if resultSearchController.active {
            //cell.textLabel?.text = filteredData[indexPath.row]
            label.text = filteredData[indexPath.row]
        }
        else {
            //cell.textLabel?.text = tableData[indexPath.row]
            label.text = tableData[indexPath.row]
        }
        
        let ContestUrlString = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
        let ContestUrl = NSURL(string: ContestUrlString)
        if ContestUrl != nil {
            let request = NSURLRequest(URL: ContestUrl!)
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let imageView = cell.viewWithTag(1) as! UIImageView
                    //imageView.image = UIImage(data: data!)
                })
            })
            
            dataTask.resume()
        }
        
        return cell
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.searchBar.text?.characters.count > 0 {
            
            filteredData.removeAll(keepCapacity: false)
            let searchPredicate = NSPredicate(format: "SELF CONTAINS %@", searchController.searchBar.text!)
            let array = (tableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
            filteredData = array as! [String]
            TeamSearch_Table.reloadData()
        }
        else{
            filteredData.removeAll(keepCapacity: false)
            filteredData = tableData
            TeamSearch_Table.reloadData()
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueTeamName" {
            let SlideMenu_TeamSearch_Focus_ViewController1 = segue.destinationViewController as! SlideMenu_TeamSearch_Focus_ViewController
            let myIndexPath = self.TeamSearch_Table.indexPathForSelectedRow!
            let row = myIndexPath.row
            SlideMenu_TeamSearch_Focus_ViewController1.teamname = tableData[row]
        }
    }

}
