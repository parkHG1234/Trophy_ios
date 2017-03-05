//

//  ViewController.swift

//  slidetest1

//

//  Created by MD313-008 on 2017. 2. 7..

//  Copyright © 2017년 MD313-008. All rights reserved.

//



import UIKit
import Alamofire
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
        
        let _Pk = dict["_Pk"] as? String
        
        Contest_Title.text = dict["_Title"] as? String
        Contest_Date.text = dict["_ContestData"] as? String
        Contest_Place.text = dict["_Place"] as? String
        
        
        
        
        
//        Alamofire.download("https://httpbin.org/image/png").responseData { response in
//            if let data = response.result.value {
//                let image = UIImage(data: data)
//                
//                let imageView = cell.viewWithTag(1) as! UIImageView
//                imageView.image = image
//                self.Contest_TableView.reloadData()
//            }
//        }
        
//        let videoString = "http://210.122.7.193:8080/Trophy_img/contest/"+self.Contest_list[indexPath.row].Image+".jpg"
//        let videoThumbnailUrl = URL(string: videoString)
//        if videoThumbnailUrl != nil{
//            
//            let request = URLRequest(url:videoThumbnailUrl!)
//            let session = URLSession.shared
//            let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
//            
//                let imageView = cell.viewWithTag(1) as! UIImageView
//                imageView.image = UIImage(data: data!)
//                } as! (Data?, URLResponse?, Error?) -> Void)
//            dataTask.resume()
//        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let Contest_Detail_View = segue.destination as! Contest_Detail_ViewController
        let myIndexPath = self.Contest_TableView.indexPathForSelectedRow!
        let row = myIndexPath.row
        
    }
    func updateSearchResults(for searchController: UISearchController) {
    
    }
    
    
    

}
