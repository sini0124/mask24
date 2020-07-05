//
//  CenterDetailViewController.swift
//  mask_24
//
//  Created by 시니 on 2020/07/03.
//  Copyright © 2020 Data Science Dept. All rights reserved.
//

import UIKit
import MapKit


class CenterDetailViewController: UIViewController {
    
    @IBOutlet var map: MKMapView!
    // Table View에서 사용자가 선택한 대학의 한 Cell 인덱스를 받아옴
    var selectedIndex: Int? = nil
    // Table View에서 선택한 대학 객체를 전달받기 위함
    var center: ScreeningCenter? = nil
    var centerAnnotation: ScreeningCenter? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCenterView" {
            if let destVC = segue.destination as? CenterTableViewController {
                destVC.mainVC = self
            }
        }
    }
}

