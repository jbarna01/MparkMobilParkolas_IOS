//
//  ParkinfDataRestore.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 06..
//  Copyright © 2020. BJ. All rights reserved.
//

import Foundation

struct ParkingAccountResponse: Decodable {
    var amount: String?;
    var plate: String?;
    var parkingId: String?;
    var result: String;
    var status: String?
}

