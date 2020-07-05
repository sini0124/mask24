
import UIKit
import CoreData

class maskDetailViewController: UIViewController {
    
    var detailMask: NSManagedObject?
    
    @IBOutlet var maskDetailView: UIView!
    @IBOutlet var imgMask: UIImageView!
    @IBOutlet var maskDate: UILabel!
    @IBOutlet var maskType: UILabel!
    @IBOutlet var maskName: UILabel!
    
    func countDays(date: String) -> Int {
        var date_lst = date.components(separatedBy: "-")
        var year = Int(date_lst[0])!
        var month = Int(date_lst[1])!
        var day = Int(date_lst[2])!
        
        //년을 일수로 치환
        var total_days = (year-1)*365 + (year-1)/4 - (year-1)/100 + (year-1)/400
        
        //월을 일수로 치환
        var months: [Int] = [31,28,31,30,31,30,31,31,30,31,30,31]
        if (year % 4 != 0) && (year % 100 != 0) || (year % 400 != 0){
            months[1] += 1}
        for i in 0..<(month-1) {
            total_days += months[i]}
        
        total_days += day
        return total_days
    }
    
    func subDate(date1: String, date2: String) -> Int {
        return countDays(date: date1) - countDays(date: date2)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let mask = detailMask {
            maskName.text = mask.value(forKey: "maskName") as? String
            maskType.text = mask.value(forKey: "maskType") as? String
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let maskdate = formatter.string(for: mask.value(forKey: "maskDate")){
                let now = formatter.string(from: Date())
                let interval = subDate(date1: now, date2: maskdate)
                maskDate.text = "\(interval)일이 지났습니다! 교체를 권장합니다~"
                switch interval {
                case 2:
                               maskDetailView.backgroundColor = UIColor(red: 0.9294, green: 0.898, blue: 0.9882, alpha: 1)
                case 3...:
                               maskDate.text = "3일이 지났으니 마스크 교체를 권장합니다!"
                               maskDetailView.backgroundColor = UIColor(red: 1, green: 0.7686, blue: 0.8314, alpha: 1)
                           default: break;
                           }
            }
            switch mask.value(forKey: "maskType") as? String {
            case "KF80":
                self.imgMask.image = UIImage(named: "dust.png")
            case "일반":
                self.imgMask.image = UIImage(named: "normal.png")
            default:
                self.imgMask.image = UIImage(named: "dust.png")
            }
        }
    }
}

