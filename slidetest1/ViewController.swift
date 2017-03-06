//

//  ViewController.swift

//  slidetest1

//

//  Created by MD313-008 on 2017. 2. 7..

//  Copyright © 2017년 MD313-008. All rights reserved.

//



import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , UISearchResultsUpdating{
    
    
    @IBOutlet weak var open: UIBarButtonItem!
    
    var isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    
    @IBOutlet var Contest_TableView: UITableView!
    var Contest_list:[Contest_Detail_Setting] = []
    var filteredData:[String] = []
    var Contest_Setting = Contest_Detail_Setting()
    
    var arrRes = [[String: AnyObject]]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if(!isUserLoggedIn) {
            UserDefaults.standard.setValue(".", forKey: "Pk")
        }
        
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.Contest_TableView.dataSource = self
        self.Contest_TableView.delegate = self
        
        let url:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/Contest_Customlist.jsp")!;
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count > 0 {
                    self.Contest_TableView.reloadData()
                    self.Contest_Setting = Contest_Detail_Setting()
                    
                    for row in self.arrRes {
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
                }
                
                print(self.arrRes)
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return self.arrRes.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContestCell", for: indexPath)
        
        
        let Contest_Title = cell.viewWithTag(2) as! UILabel
        let Contest_Date = cell.viewWithTag(3) as! UILabel
        let Contest_Place = cell.viewWithTag(4) as! UILabel
        
        var dict = arrRes[indexPath.row]
        var Contest_Pk = dict["_Pk"] as? String
        Contest_Title.text = dict["_Title"] as? String
        Contest_Date.text = dict["_ContestData"] as? String
        Contest_Place.text = dict["_Place"] as? String
        let imageName:String = dict["_Image"] as! String
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_img/contest/\(imageName).jpg")
            .responseImage { response in
                debugPrint(response)
                //print(response.request)
                //print(response.response)
                //debugPrint(response.result)
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    // Store the commit date in to our cache
                    // Update the cell
                    DispatchQueue.main.async(execute: {
                        if let cellToUpdate = tableView.cellForRow(at: indexPath) {
                            let dishImageView:UIImageView = cellToUpdate.viewWithTag(1) as! UIImageView
                            dishImageView.image = image
                            
                        }
                    });
                }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let Contest_Detail_View = segue.destination as! Contest_Detail_ViewController
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
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    
    
    
}
