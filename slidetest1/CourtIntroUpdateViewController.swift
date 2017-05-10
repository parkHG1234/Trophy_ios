//
//  CourtIntroUpdateViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 5. 8..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class CourtIntroUpdateViewController: UIViewController {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var courtIntroTextView: UITextView!

    var userPk:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
