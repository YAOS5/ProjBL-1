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

func postAPIRequest(url: String, params: [String: Any], completion: @escaping (JSON?)-> Void) {
    
    var json = JSON()

    Alamofire.request(chaliceUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
        response in
        switch response.result {
        case .success:
            json = JSON(response.result.value!)
            completion(json)
        case .failure:
            completion(nil)
        }
    }
}
