
import UIKit

class LogoutViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let name = appDelegate.userName {
            self.nameLabel.text = "Hello ~  " + name
        }
    }
    
    
    @IBAction func buttonLogout(_ sender: UIButton) {
        //        self.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/M09/login/logout.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return } }
            task.resume()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = storyboard.instantiateViewController(withIdentifier: "loginView")
            loginView.modalPresentationStyle = .fullScreen
            self.present(loginView, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
