//
//  MatchUploadViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 23..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class MatchUploadViewController: UIViewController {

    @IBOutlet weak var matchUploadTeamEmblem: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.matchUploadTeamEmblem.layer.cornerRadius = self.matchUploadTeamEmblem.frame.size.width/2
        self.matchUploadTeamEmblem.clipsToBounds = true
    }
}
