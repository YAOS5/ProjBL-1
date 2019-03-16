//
//  FilterCell.swift
//  ProjBL
//
//  Created by Peteski Shi on 17/3/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var cafeButton: UIButton!
    @IBOutlet weak var computerButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cafeButton.isHidden = true
        computerButton.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func changeToFilter() {
        cafeButton.isHidden = false
        computerButton.isHidden = false
        mainLabel.text = "Filter"
    }
    
    
    
    @IBAction func cafeButtonPressed(_ sender: UIButton) {
        cafeButton.isHighlighted = true
    }
    
    @IBAction func computerButton(_ sender: UIButton) {
        computerButton.isHighlighted = true
    }
    
}
