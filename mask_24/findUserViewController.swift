
import UIKit

class findUserViewController: UIViewController {
    
    @IBOutlet var findIdLabel: UILabel!
    @IBOutlet var findIdHint: UITextField!
    @IBOutlet var findIdName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func findIdPressed(_ sender: UIButton) {
        if findIdName.text == "" {
            findIdLabel.text = "이름을 입력하세요"; return;
        }
        if findIdHint.text == "" {
            findIdLabel.text = "힌트를 입력하세요"; return;
        }
        let urlString: String = "http://condi.swu.ac.kr/student/M09/login/findUserId.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        self.findIdLabel.text = " "
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "name=" + findIdName.text! + "&hint=" + findIdHint.text!
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
                    if let id = jsonData["id"] as? String {
                        DispatchQueue.main.async {
                            self.findIdLabel.text = "id는 " + id + "입니다."
                        }
                    }
                } else {
                    if let errMessage = jsonData["error"] as? String {
                        DispatchQueue.main.async {
                            self.findIdLabel.text = errMessage }
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
