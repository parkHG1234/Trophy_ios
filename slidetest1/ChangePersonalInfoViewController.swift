//
//  ChangePersonalInfoViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 2. 22..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class ChangePersonalInfoViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var addressDoLabel: UILabel!
    @IBOutlet weak var addressSiLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var Pk:String = UserDefaults.standard.string(forKey: "Pk")!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async(execute: {
            
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
            self.profileImageView.clipsToBounds = true
        })

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part3/ChangePersonalInfo_ios.jsp")!);
//        request.httpMethod = "POST";
//        
//        let postString = "Data1=\(Pk)";
//        request.httpBody = postString.data(using: String.Encoding.utf8);
//        
//        
//        
//        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in guard error == nil && data != nil else {       // check for fundamental networking error
//            print("error=\(error)")
//            return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
//            
//            let responseString:String = String(data: data!, encoding: String.Encoding.utf8)!
//            print("responseString = \(responseString)")
//            
//            
//            var json:NSDictionary?;
//            
//            do {
//                json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//            } catch let error as NSError {
//                print("error : \(error)")
//            }
//            
//            if let parseJSON = json {
//                DispatchQueue.main.async(execute: {
//                    
//                    let name:String = (parseJSON["Name"] as? String)!
//                    self.nameLabel.text = name
//                    print("name: \(name)")
//                    
//                    let sex:String = (parseJSON["Sex"] as? String)!
//                    if(sex == "W") {
//                        self.sexLabel.text = "여자"
//                        print("sex: \(sex)")
//                    }else {
//                        self.sexLabel.text = "남자"
//                        print("sex: \(sex)")
//                    }
//                    
//                    let birth:String = (parseJSON["Birth"] as? String)!
//                    self.birthLabel.text = birth
//                    print("birth: \(birth)")
//                    
//                    let addressDo:String = (parseJSON["Do"] as? String)!
//                    self.addressDoLabel.text = addressDo
//                    print("addressDo: \(addressDo)")
//                    
//                    let addressSi:String = (parseJSON["Si"] as? String)!
//                    self.addressSiLabel.text = addressSi
//                    print("addressSi: \(addressSi)")
//                    
//                    let phone:String = (parseJSON["Phone"] as? String)!
//                    self.phoneLabel.text = phone
//                    print("phone: \(phone)")
//                    
//                });
//            }
//        }) 
//        task.resume()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
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
