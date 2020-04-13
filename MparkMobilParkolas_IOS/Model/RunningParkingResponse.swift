//
//  RunningParkingResponse.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 13..
//  Copyright © 2020. BJ. All rights reserved.
//

import Foundation

struct RunningParkingResponse: Decodable {
    var parkingId: String?;
    var start: String?;
    var duration: String?;
    var parkingCost: String?;
    var zoneCost: String?;
    var result: String;
}
