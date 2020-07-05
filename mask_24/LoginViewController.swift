//
//  ViewController.swift
//  ServerLogin
//
//  Created by 시니 on 2020/06/01.
//  Copyright © 2020 Data Science Dept. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var loginUserid: UITextField!
    @IBOutlet var loginPassword: UITextField!
    @IBOutlet var labelStatus: UILabel!
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginUserid {
            textField.resignFirstResponder()
            self.loginPassword.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func loginPressed() { // 추가적으로 수정함
        
        if loginUserid.text == "" {
            labelStatus.text = "ID를 입력하세요"; return;
        }
        if loginPassword.text == "" {
            labelStatus.text = "비밀번호를 입력하세요"; return;
        }
        let urlString: String = "http://condi.swu.ac.kr/student/M09/login/loginUser.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        self.labelStatus.text = " "
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + loginUserid.text! + "&password=" + loginPassword.text!
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            do {
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    print ("HTTP Error!")
                    return
                }
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [String: Any] else {
                    print("JSON Serialization Error!")
                    return
                }
                guard let success = jsonData["success"] as? String else {
                    print("Error: PHP failure(success)")
                    return
                }
                
                if success == "YES" {
                    if let name = jsonData["name"] as? String, let userid = jsonData["userid"] as? String {
                        DispatchQueue.main.async {
                            self.labelStatus.text = name + "님 안녕하세요?"
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.userName = name
                            appDelegate.userId = userid
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let TabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
                            
                            TabBarController.modalPresentationStyle = .fullScreen
                            self.present(TabBarController, animated: true, completion: nil)
                        }
                    }
                } else {
                    if let errMessage = jsonData["error"] as? String {
                        DispatchQueue.main.async {
                            self.labelStatus.text = errMessage }
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

