//
//  CenterTableViewController.swift

import UIKit
import MapKit


class CenterTableViewController: UITableViewController {
    
    @IBOutlet var CenterTableView: UITableView!
    // 대학 정보를 저장하기 위함
    var centers: [ScreeningCenter] = []
    // 지도가 있는 상위 View: 선택한 정보를 전달해 주기 위함
    var mainVC: CenterDetailViewController? = nil
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String = "http://condi.swu.ac.kr/student/M09/login/getCenter.php"
        guard let requestURL = URL(string: urlString) else {
            return }
        
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared.dataTask(with: request) {(responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            
//            print("DATATASK handler start")
            
            do {
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    print ("HTTP Error!")
                    return
                }
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData) as? [[String: String]] else {
                    print("JSON Serialization Error!")
                    return
                }
                for i in 0 ..< jsonData.count
                {
                    let jsonElement = jsonData[i] as NSDictionary
                    DispatchQueue.main.async {
                        let center = ScreeningCenter(title:jsonElement["c_name"] as! String, latitude: Double(jsonElement["lat"] as! String)!, longitude: Double(jsonElement["long"] as! String)!)
                        self.centers.append(center)
                        self.CenterTableView.reloadData()
                    }
                }
            } catch {
                print("Error: \(error)")
            }
            
//            print("DATATASK handler end")
        }
//        print("DATATASK defined")
        session.resume()
//        print("DATATASK resumed")
        //        CenterTableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) ->
        String? {
            return "선별진료소를 선택하세요"
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
        Int {
            return self.centers.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mainVC?.selectedIndex = indexPath.row
        self.mainVC?.center = self.centers[indexPath.row]
        self.tableView.reloadData()
        if let _ = mainVC?.selectedIndex {
            mainVC?.map.setRegion(MKCoordinateRegion(
                center: (mainVC?.center?.coordinate)!,
                span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)),
                          animated: true)
        }
        // 기존의 맵에 annotation이 있었다면 삭제
        if let annotation = mainVC?.centerAnnotation {
            mainVC?.map.removeAnnotation(annotation)
        }
        
        // 새로운 annotation 위치가 있다면 추가
        if let annotation = mainVC?.center {
            mainVC?.centerAnnotation = annotation
            mainVC?.map.addAnnotation((mainVC?.centerAnnotation)!)
        }
        
        self.presentingViewController?.viewWillAppear(true)
        // in iOS 13 for modal view dismiss
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Center Cell", for: indexPath)
            // Configure the cell...
            cell.textLabel?.text = self.centers[indexPath.row].title
            if let view = self.mainVC {
                if let index = view.selectedIndex {
                    if index == indexPath.row {
                        cell.accessoryType = .checkmark
                    }
                    else {
                        cell.accessoryType = .none
                    }
                }
            }
            return cell
    }
    
}
