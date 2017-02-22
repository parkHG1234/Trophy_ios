//
//  SlideMenuViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 8..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController {

    @IBOutlet weak var Profile: UIImageView!
    @IBOutlet weak var SportType: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    
    var isUserLoggedIn:Bool = false
    var Pk:String = ""
    override func viewDidAppear(animated: Bool) {
        self.reloadInputViews()
        isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        
        if(isUserLoggedIn) {
            // Do any additional setup after loading the view.
            Pk = NSUserDefaults.standardUserDefaults().stringForKey("Pk")!
            let url = NSURL(string:"http://210.122.7.193:8080/Trophy_img/profile/\(Pk).jpg")
            let data = NSData(contentsOfURL:url!)
            
            dispatch_async(dispatch_get_main_queue(),{
                self.Profile.image = UIImage(data:data!)
                self.profileButton.setTitle("\(self.Pk)", forState: .Normal)
            });
            
        }else {
            // Do any additional setup after loading the view.
            let url = NSURL(string:"http://210.122.7.193:8080/Trophy_img/profile/18.jpg")
            let data = NSData(contentsOfURL:url!)
            Profile.image = UIImage(data:data!)
            profileButton.setTitle("로그인을 해주세요", forState: .Normal)
        }
        
        dispatch_async(dispatch_get_main_queue(),{
            self.SportType.image = UIImage(named: "basketball_a.png")
        });
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = NSURL(string:"http://210.122.7.193:8080/Trophy_img/profile/18.jpg")
        let data = NSData(contentsOfURL:url!)
        dispatch_async(dispatch_get_main_queue(), {
            self.Profile.image = UIImage(data:data!)
        });
        SportType.image = UIImage(named: "basketball_a.png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().setValue(".", forKey: "Pk")
        NSUserDefaults.standardUserDefaults().synchronize()
    
        viewDidAppear(true)
    }
    
    
    @IBAction func profileButtonTapped(sender: AnyObject) {
        if(isUserLoggedIn) {
            // 회원정보변경 페이지 이동
        }else {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(vc!, animated: true, completion: nil)
        }
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
