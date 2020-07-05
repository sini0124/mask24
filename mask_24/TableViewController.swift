import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    
    @IBOutlet var maskTableView: UITableView!

    var maskArray: [NSManagedObject] = []
        let formatter: DateFormatter = DateFormatter()
        
        
        func numberOfSections (in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int)->Int {
            return maskArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            formatter.dateFormat = "yyyy-MM-dd"
            let cell = self.maskTableView.dequeueReusableCell(withIdentifier: "Mask Cell", for:
            indexPath) as! MaskCell
            // Configure the cell...
            let mask = maskArray[indexPath.row]
            if let nameLabel = mask.value(forKey: "maskName") as? String {
                cell.maskName.text = nameLabel
            }
            if let typeLabel = mask.value(forKey: "maskType") as? String {
                cell.maskType.text = typeLabel
            }
            cell.maskDate.text = formatter.string(from: mask.value(forKey: "maskDate") as! Date)
            
            switch mask.value(forKey: "maskType") as? String {
                case "KF80":
                    cell.imgMask.image = UIImage(named: "dust.png")
                case "일반":
                    cell.imgMask.image = UIImage(named: "normal.png")
                default:
                    cell.imgMask.image = UIImage(named: "dust.png")
                }
                return cell
            }

    
        func getContext () -> NSManagedObjectContext {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Core Data 내의 해당 자료 삭제
                let context = getContext()
                context.delete(maskArray[indexPath.row])
                do {
                    try context.save()
                    print("deleted!")
                } catch let error as NSError {
                    print("Could not delete \(error), \(error.userInfo)") }
                // 배열에서 해당 자료 삭제
                maskArray.remove(at: indexPath.row)
                // 테이블뷰 Cell 삭제
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            maskArray = []
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = self.getContext()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Mask")
            let sortDescriptor = NSSortDescriptor (key: "maskName", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                let masks = try context.fetch(fetchRequest)
                for data in masks{
                    if data.value(forKey: "maskUser") as? String == appDelegate.userId{
                        maskArray.append(data)
                    }
                }
            }catch let error as NSError{
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            self.maskTableView.reloadData()
        }
        
        
        override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toDetailView" {
                if let destination = segue.destination as? maskDetailViewController {
                    if let selectedIndex = self.maskTableView.indexPathsForSelectedRows?.first?.row {
                        destination.detailMask = maskArray[selectedIndex] }
                }
            }
        }
    }
