//
//  MaskCell.swift
//  mask_24
//
//  Created by 시니 on 2020/06/26.
//  Copyright © 2020 Data Science Dept. All rights reserved.
//

import UIKit

class MaskCell: UITableViewCell {
    
    @IBOutlet var imgMask: UIImageView!
    @IBOutlet var maskName: UILabel!
    @IBOutlet var maskType: UILabel!
    @IBOutlet var maskDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
