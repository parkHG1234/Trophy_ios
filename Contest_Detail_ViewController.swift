//

//  Contest_Detail_ViewController.swift

//  slidetest1

//

//  Created by MD313-007 on 2017. 2. 14..

//  Copyright © 2017년 MD313-008. All rights reserved.

//



import UIKit



class Contest_Detail_ViewController: UIViewController , UISearchResultsUpdating {
    
    @IBOutlet var Contest_PopUp_View: UIView!
    @IBOutlet var Contest_PopUp_ImageView: UIImageView!
    @IBOutlet var Background_Button: UIButton!
    @IBOutlet var Detail_Image: UIImageView!
    @IBOutlet var Detail_Title: UILabel!
    @IBOutlet var Detail_Host: UILabel!
    @IBOutlet var Detail_Management: UILabel!
    @IBOutlet var Detail_Support: UILabel!
    @IBOutlet var Detail_Payment: UILabel!
    @IBOutlet var Detail_RecruitStartDate: UILabel!
    @IBOutlet var Detail_ContestDate: UILabel!
    @IBOutlet var Detail_Place: UILabel!
    @IBOutlet var Detail_DetailInfo: UILabel!
    
    @IBOutlet var Contest_ScrollView: UIScrollView!
    
    
    var Contest_Pk:String = ""
    var Contest_Title:String = ""
    var Contest_Image:String = ""
    var Contest_CurrentNum:String = ""
    var Contest_MaxNum:String = ""
    var Contest_Payment:String = ""
    var Contest_Host:String = ""
    var Contest_Management:String = ""
    var Contest_Support:String = ""
    var Contest_ContestDate:String = ""
    var Contest_RecruitStartDate:String = ""
    var Contest_RecruitFinishDate:String = ""
    var Contest_DetailInfo:String = ""
    var Contest_Place:String = ""
    override func viewDidLoad() {
        
        //Make BackGround Detail Information
        
        Detail_Title.text = Contest_Title
        Detail_Host.text = Contest_Host
        Detail_Management.text = Contest_Management
        Detail_Support.text = Contest_Support
        Detail_Payment.text = Contest_Payment
        Detail_RecruitStartDate.text = Contest_RecruitStartDate
        Detail_ContestDate.text = Contest_ContestDate
        Detail_Place.text = Contest_Place
        Detail_DetailInfo.text = Contest_DetailInfo
        
        
        Contest_ScrollView.contentSize.height = 1000
        
        let videoString = "http://210.122.7.193:8080/Trophy_img/contest/"+self.Contest_Image+".jpg"
        let videoThumbnailUrl = URL(string: videoString)
        
        if videoThumbnailUrl != nil{
            let request = URLRequest(url:videoThumbnailUrl!)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                
                let imageView = self.Detail_Image
                imageView?.image = UIImage(data: data!)
                
            } as! (Data?, URLResponse?, Error?) -> Void)
            
            dataTask.resume()
            
    }
    
    func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    func Done(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }
        
        
        
        
}
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let Contest_Application_View = segue.destination as! Contest_Application_ViewController
        
        Contest_Application_View.User_Pk = "18"
        Contest_Application_View.Contest_Pk = "3"
        Contest_Application_View.MyTeamName = "AldongTeam"
    }

    func updateSearchResults(for searchController: UISearchController) {
        
    }
    @IBAction func Contest_PopUp_More(_ sender: AnyObject) {
    }
    @IBAction func Contest_PopUp_Close(_ sender: AnyObject) {
        Contest_PopUp_View.isHidden = true
        Background_Button.alpha = 0
    }
}
