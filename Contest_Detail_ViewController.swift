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
        
        let videoString = "http://210.122.7.193:8080/Trophy_img/contest/"+self.Contest_Image+".jpg"
        let videoThumbnailUrl = NSURL(string: videoString)
        
        if videoThumbnailUrl != nil{
            let request = NSURLRequest(URL:videoThumbnailUrl!)
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                
                let imageView = self.Detail_Image
                imageView.image = UIImage(data: data!)
                
            })
            
            dataTask.resume()
            
    }
    
    func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    func Done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
        
        
        
        
}
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let Contest_Application_View = segue.destinationViewController as! Contest_Application_ViewController
        
        Contest_Application_View.Contest_Pk = "18"
        Contest_Application_View.MyTeamName = "AldongTeam"
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    @IBAction func Contest_PopUp_More(sender: AnyObject) {
    }
    @IBAction func Contest_PopUp_Close(sender: AnyObject) {
        Contest_PopUp_View.hidden = true
        Background_Button.alpha = 0
    }
}
