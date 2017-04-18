//
//  TeamCreateViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 6..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


extension UIViewController: UITextFieldDelegate, UITextViewDelegate {
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    func addToolBar(textView: UITextView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textView.delegate = self
        textView.inputAccessoryView = toolBar
    }
    
    func donePressed() {
        view.endEditing(true)
    }
    
    func cancelPressed() {
        view.endEditing(true) // or do something
    }
}

class TeamCreateViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var teamEmblemButton: UIButton!
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamAddressDoTextField: UITextField!
    @IBOutlet weak var teamAddressSiTextField: UITextField!
    @IBOutlet weak var teamHomeCourtTextField: UITextField!
    @IBOutlet weak var teamIntroTextView: UITextView!
    
    var url = "".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    
    var userPk:String = ""
    
    var teamName:String = ""
    var teamAddressDo:String = ""
    var teamAddressSi:String = ""
    var teamHomeCourt:String = ""
    var teamIntro:String = ""
    var isTeamEmblemChanged:Bool = false
    
    var arrRes = [[String:AnyObject]]()
    var teamEmblemImage:Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        
        DispatchQueue.main.async(execute: {
            
            self.teamEmblemButton.layer.cornerRadius = self.teamEmblemButton.frame.size.width/2
            self.teamEmblemButton.clipsToBounds = true
        })
        
        addToolBar(textField: teamNameTextField)
        addToolBar(textField: teamAddressDoTextField)
        addToolBar(textField: teamAddressSiTextField)
        addToolBar(textField: teamHomeCourtTextField)
        addToolBar(textView: teamIntroTextView)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func teamEmblemButtonTapped(_ sender: Any) {

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let libButton = UIAlertAction(title: "라이브러리에서 선택", style: UIAlertActionStyle.default, handler: { (libSelected) -> Void in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        })
        actionSheet.addAction(libButton)
        let cameraButton = UIAlertAction(title: "사진 찍기", style: UIAlertActionStyle.default, handler: { (cameraSeleted) -> Void in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickerController, animated: true, completion: nil)
        })
        actionSheet.addAction(cameraButton)
        let cancelButton = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: { (cancelSeleted) -> Void in
            
        })
        actionSheet.addAction(cancelButton)
        self.present(actionSheet, animated: true, completion: nil)
        

    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            teamEmblemButton.setImage(image, for: .normal)
            
            self.teamEmblemImage = UIImageJPEGRepresentation(image, 1)!
            
        }else {
            print("error")
        }
        //myimage.backgroundColor = UIColor.clearColor()
        self.dismiss(animated: true, completion: nil)
    }

    

    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        teamName = teamNameTextField.text!
        teamAddressDo = teamAddressDoTextField.text!
        teamAddressSi = teamAddressSiTextField.text!
        teamHomeCourt = teamHomeCourtTextField.text!
        teamIntro = teamIntroTextView.text!
        
        if(teamName.isEmpty || teamAddressDo.isEmpty || teamAddressSi.isEmpty || teamHomeCourt.isEmpty || teamIntro.isEmpty) {
            let myAlert = UIAlertController(title: "팀 생성", message: "이미 존재하는 팀명 입니다", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
            
            return
        }
        
        if(isTeamEmblemChanged) {
            self.url = "http://210.122.7.193:8080/Trophy_part3/TeamCreate.jsp?Data1=\(userPk)&Data2=\(teamName)&Data3=\(teamAddressDo)&Data4=\(teamAddressSi)&Data5=\(teamHomeCourt)&Data6=\(teamIntro)&Data7=\(teamName)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        }else {
            self.url = "http://210.122.7.193:8080/Trophy_part3/TeamCreate.jsp?Data1=\(userPk)&Data2=\(teamName)&Data3=\(teamAddressDo)&Data4=\(teamAddressSi)&Data5=\(teamHomeCourt)&Data6=\(teamIntro)&Data7=.".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        }
        
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print(self.arrRes)
                    if(self.arrRes.count > 0) {
                        if(self.arrRes[0]["status"]! as! String == "succed") {
                            if(self.isTeamEmblemChanged) {
                                self.uploadWithAlamofire(self.teamName)
                            }
                            let myAlert = UIAlertController(title: "팀 생성", message: "팀 생성이 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                self.dismiss(animated: true, completion: nil)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }else if(self.arrRes[0]["status"]! as! String == "duplicate") {
                            let myAlert = UIAlertController(title: "팀 생성", message: "이미 존재하는 팀명 입니다", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }else {
                            let myAlert = UIAlertController(title: "에러", message: "잠시후 다시 시도해 주세요", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    
    func uploadWithAlamofire(_ teamName:String) {
        // define parameters
//        let parameters = [
//            "hometown": "yalikavak",
//            "living": "istanbul"
//        ]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(self.teamEmblemImage!, withName: "file" , fileName: "\(teamName).jpg", mimeType: "image/jpg")},
                         to: "http://210.122.7.193:8080/Trophy_part3/TeamImageUpload.jsp",
                         method: .post,
                         headers: ["Authorization": "auth_token"],
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.response { [weak self] response in
                                    guard let strongSelf = self else {
                                        return
                                    }
                                    debugPrint(response)
                                }
                            case .failure(let encodingError):
                                print("error:\(encodingError)")
                            }
        })
   
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
