//
//  studySpaceData.swift
//  ProjBL
//
//  Created by Lexon on 18/3/2019.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class StudySpaceAPI {
    var buildings = [String : Any]()
    func getStudySpaceData(postUrl url: String, latitude lat: Double, longitude long: Double) {
        //MARK: Call API with post request
        let params = ["lat": lat, "long": long]
        postAPIRequest(url: url, params: params) {data in
            if let json = data {
                self.buildings = json.dictionaryObject! as [String : Any]
            } else {
                print("API request returned error")
            }
        }
    }
}
