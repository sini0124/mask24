import UIKit
import CoreData



class addMaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let typeArray = ["KF94", "KF80", "일반"]
    @IBOutlet var maskName: UITextField!
    @IBOutlet var maskType: UIPickerView!
    @IBOutlet var maskDate: UIDatePicker!
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { textField.resignFirstResponder()
        return true }
    
    func numberOfComponents(in pickerView: UIPickerView)->Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component:Int) -> Int {
        return typeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)->String? {
        return typeArray[row]
    }
    
    
    

    
    @IBAction func savePressed(_ sender: Any) {
        //        let dateformatter = DateFormatter()
        
        let context = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Mask", in: context)
        // mask record를 새로 생성함
        
        let object = NSManagedObject(entity: entity!, insertInto: context)
        
        object.setValue(maskName.text, forKey: "maskName")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print(appDelegate.userId)
        object.setValue(appDelegate.userId, forKey: "maskUser")
        object.setValue(typeArray[self.maskType.selectedRow(inComponent: 0)], forKey: "maskType")
        object.setValue(maskDate.date, forKey: "maskDate")
        
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        // 현재의 View를 없애고 이전 화면으로 복귀
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
