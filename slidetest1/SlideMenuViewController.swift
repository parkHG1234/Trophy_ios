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
    @IBOutlet weak var slideMenuWidthConstraint: NSLayoutConstraint!
    
    var isUserLoggedIn:Bool = false
    var Pk:String = ""
    override func viewDidAppear(_ animated: Bool) {
        self.reloadInputViews()
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if(isUserLoggedIn) {
            // Do any additional setup after loading the view.
            Pk = UserDefaults.standard.string(forKey: "Pk")!
            let url = URL(string:"http://210.122.7.193:8080/Trophy_img/profile/\(Pk).jpg")
            let data = try? Data(contentsOf: url!)
            
            DispatchQueue.main.async(execute: {
                self.Profile.image = UIImage(data:data!)
                
                self.profileButton.setTitle("\(self.Pk)", for: UIControlState())
                self.profileButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            });
            
        }else {
            // Do any additional setup after loading the view.
            Profile.image = UIImage(named: "user_basic")
            profileButton.setTitle("로그인을 해주세요", for: UIControlState())
            profileButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        }
        
        DispatchQueue.main.async(execute: {
            self.SportType.image = UIImage(named: "basketball_a.png")
        });
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 100
        DispatchQueue.main.async(execute: {
            self.Profile.layer.cornerRadius = self.Profile.frame.size.width/2
            self.Profile.clipsToBounds = true
        })
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.setValue(".", forKey: "Pk")
        UserDefaults.standard.synchronize()
    
        viewDidAppear(true)
    }
    
    
    
    @IBAction func profileButtonTapped(_ sender: AnyObject) {
        print(isUserLoggedIn)
        if(isUserLoggedIn == true) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "changePersonalInfoNavigationController")
            
            self.present(vc!, animated: true, completion: nil)
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginNavigationController")
            
            self.present(vc!, animated: true, completion: nil)
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
