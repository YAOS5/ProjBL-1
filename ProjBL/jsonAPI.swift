//
//  venueAPI.swift
//  ProjBL
//
//  Created by Lexon on 16/3/2019.
//  Copyright © 2019 Petech. All rights reserved.
//
import Foundation
import Alamofire
import CoreLocation
import SwiftyJSON

let urlString = "https://572g8um8v0.execute-api.us-east-1.amazonaws.com/dev/getvenueinfo"

func getJSON(lat: CLLocationDegrees, long: CLLocationDegrees) -> JSON{
    var json = JSON()
    Alamofire.request(urlString, method: .post, parameters: ["lat": Double(lat), "long": Double(long)], encoding: JSONEncoding.default, headers: nil).responseJSON {
        response in
        switch response.result {
        case .success:
            json = JSON(response.result.value!)
        case .failure(let error):
            print(error)
        }
    }
    return json
}
