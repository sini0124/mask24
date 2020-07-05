import UIKit
import CoreData

class MaskTableViewController: UITableViewController {
    
    var maskArray: [NSManagedObject] = []
    let formatter: DateFormatter = DateFormatter()
    
    
    override func numberOfSections (in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int)->Int {
        return maskArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        formatter.dateFormat = "yyyy-MM-dd"
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mask Cell", for: indexPath)
        // Configure the cell...
        let mask = maskArray[indexPath.row]
        var display: String = ""
        if let nameLabel = mask.value(forKey: "maskName") as? String {
            display = nameLabel
        }
        if let typeLabel = mask.value(forKey: "maskType") as? String {
            display = display + " " + typeLabel
        }
        cell.textLabel?.text = display
        cell.detailTextLabel?.text = formatter.string(from: mask.value(forKey: "maskDate") as! Date)
        return cell
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        
        self.tableView.reloadData()
    }
    
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            if let destination = segue.destination as? maskDetailViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    destination.detailMask = maskArray[selectedIndex] }
            }
        }
    }
}
