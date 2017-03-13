//
//  SlideMenu_TeamSearch_TableViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 8..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class SlideMenu_TeamSearch_TableViewController: UITableViewController, UISearchResultsUpdating {
    
    var Team_List:[TeamSearchSetting] = []
    var Team_Setting = TeamSearchSetting()
    
    var tableData = [String]()
    var filteredData:[String] = []
    var resultSearchController:UISearchController!
    var arrRes:[[String:AnyObject]] = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading comsllslsslslsll")
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/TeamSearch.jsp").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                print(responseData.result)
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("aaaaaaa\(self.arrRes)")
                }
                for row in self.arrRes{
                    
                    self.Team_Setting = TeamSearchSetting()
                    self.Team_Setting.teamName = ((row["teamName"] as? String)!)
                    self.Team_Setting.teamEmblem = ((row["teamEmblem"] as? String)!)
                    self.Team_Setting.teamPk = ((row["teamPk"] as? String)!)
                    self.Team_Setting.teamAddressDo = ((row["teamAddressDo"] as? String)!)
                    self.Team_Setting.teamAddressSi = ((row["teamAddressSi"] as? String)!)
                    self.Team_Setting.teamHomeCourt = ((row["teamHomeCourt"] as? String)!)
                    self.Team_Setting.teamIntroduce = ((row["teamIntroduce"] as? String)!)
                    self.Team_Setting.teamImage1 = ((row["teamImage1"] as? String)!)
                    self.Team_Setting.teamImage2 = ((row["teamImage2"] as? String)!)
                    self.Team_Setting.teamImage3 = ((row["teamImage3"] as? String)!)
                    
                    
                    self.Team_List.append(self.Team_Setting)
                    self.tableData.append((row["teamName"] as? String)!)
                    self.tableView.reloadData()
                    
                }
            }
        }
        
        
        //검색어 구현
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = resultSearchController.searchBar
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
    
    // MARK: - Table view data source
    @IBAction func Back_Button_Action(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if resultSearchController.isActive {
            return filteredData.count
        }
        else{
            return tableData.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let label = cell.viewWithTag(2) as! UILabel
        // Configure the cell...
        if resultSearchController.isActive {
            //cell.textLabel?.text = filteredData[indexPath.row]
            label.text = filteredData[indexPath.row]
        }
        else {
            //cell.textLabel?.text = tableData[indexPath.row]
            label.text = tableData[indexPath.row]
        }
        var dict = arrRes[indexPath.row]
        let imageName:String = dict["teamEmblem"] as! String
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_img/team/\(imageName).jpg")
            .responseImage { response in
                
                if let image = response.result.value {
                    DispatchQueue.main.async(execute: {
                        let imageView = cell.viewWithTag(1) as! UIImageView
                        imageView.image = image
                        
                    });
                }
        }
        
        return cell
    }
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.characters.count > 0 {
            
            filteredData.removeAll(keepingCapacity: false)
            let searchPredicate = NSPredicate(format: "SELF CONTAINS %@", searchController.searchBar.text!)
            let array = (tableData as NSArray).filtered(using: searchPredicate)
            filteredData = array as! [String]
            tableView.reloadData()
        }
        else{
            filteredData.removeAll(keepingCapacity: false)
            filteredData = tableData
            tableView.reloadData()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTeamDetail" {
            let TeamDetailViewController = segue.destination as! TeamDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            TeamDetailViewController.teamPk = Team_List[row].teamPk
            TeamDetailViewController.teamName = Team_List[row].teamName
            TeamDetailViewController.teamEmblem = Team_List[row].teamEmblem
            TeamDetailViewController.teamImage1 = Team_List[row].teamImage1
            TeamDetailViewController.teamImage2 = Team_List[row].teamImage2
            TeamDetailViewController.teamImage3 = Team_List[row].teamImage3
            TeamDetailViewController.teamAddressDo = Team_List[row].teamAddressDo
            TeamDetailViewController.teamAddressSi = Team_List[row].teamAddressSi
            TeamDetailViewController.teamIntroduce = Team_List[row].teamIntroduce
            TeamDetailViewController.teamHomeCourt = Team_List[row].teamHomeCourt
            
        }
    }
}
