//
//  SlideMenu_TeamSearch_Focus_ViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 10..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class SlideMenu_TeamSearch_Focus_ViewController: UIViewController {
   // @IBOutlet weak var TeamSearch_Focus_Introduce: UILabel!
  //  @IBOutlet weak var TeamSearch_Focus_HomeCourt: UILabel!
  //  @IBOutlet weak var TeamSearch_Focus_TeamAddress: UILabel!
   // @IBOutlet weak var TeamSearch_Focus_TeamName: UILabel!
    var teamname : String = ""
    
    var TeamName = [String]()
    var TeamAddress_Do = [String]()
    var TeamAddress_Se = [String]()
    var HomeCourt = [String]()
    var Introduce = [String]()
    func preview (){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //http 통신
        let request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part1/TeamSearch_Focus.jsp")!)
        let parameterString = "Data1="+teamname
        
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
                    self.TeamName.append((row["msg1"] as? String)!)
                    self.TeamAddress_Do.append((row["msg2"] as? String)!)
                    self.TeamAddress_Se.append((row["msg3"] as? String)!)
                    self.HomeCourt.append((row["msg4"] as? String)!)
                    self.Introduce.append((row["msg5"] as? String)!)
                }
            }catch{
                
            }
          //  self.TeamSearch_Focus_TeamName.text = self.TeamName[0]
           // self.TeamSearch_Focus_TeamAddress.text = self.TeamAddress_Do[0] + " " + self.TeamAddress_Se[0]
           // self.TeamSearch_Focus_HomeCourt.text = self.HomeCourt[0]
           // self.TeamSearch_Focus_Introduce.text = self.Introduce[0]
            //self.view.setNeedsDisplay()
        }
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
