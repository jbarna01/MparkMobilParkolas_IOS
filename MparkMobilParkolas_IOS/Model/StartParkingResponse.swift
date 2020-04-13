//
//  StartParkingResponse.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 07..
//  Copyright © 2020. BJ. All rights reserved.
//

import Foundation

struct StartParkingResponse: Decodable {
    var parkingId: String?;
    var duration: String?;
    var parkingCost: String?;
    var zoneCost: String?;
    var result: String?;
}
