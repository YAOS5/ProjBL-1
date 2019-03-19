//
//  studySpaceModel.swift
//  ProjBL
//
//  Created by Lexon on 18/3/2019.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation

struct Room {
    var roomName: String
    var hasAV: Bool
    var hasComputers: Bool
}

struct Building {
    var buildingName: String
    var busyness: Double
    var distance: Double
    var time: String
    var openingTime: String
    var closingTime: String
    var latitude: Double
    var longitude: Double
    var closeToCafe: Bool
    var hasVending: Bool
    var hasATM: Bool
    var hasMicrowave: Bool
    var hasPrinting: Bool
    var rooms: [Room]
}
