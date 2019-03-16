//
//  retractKeyboard.swift
//  ProjBL
//
//  Created by Peteski Shi on 17/3/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
