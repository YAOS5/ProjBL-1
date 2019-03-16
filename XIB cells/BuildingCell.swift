//
//  BuildingCell.swift
//  ProjBL
//
//  Created by Peteski Shi on 16/3/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit

class BuildingCell: UITableViewCell {
    
    @IBOutlet weak var libraryName: UILabel!
    @IBOutlet weak var walkingMinutes: UILabel!
    @IBOutlet weak var walkingMeters: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func directionButtonPressed(_ sender: UIButton) {
        let viewController = ViewController()
//        viewController.plotDirectionsTo(destName: libraryName.text!, lat: ?, long: ?)
    }
}
