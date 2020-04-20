//
//  AccountOnePlatesResponse.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 14..
//  Copyright © 2020. BJ. All rights reserved.
//

import Foundation

struct AccountOnePlatesResponse: Decodable {
    var result: String
    var allPlates: OnePlates?
}
struct OnePlates: Decodable{
    var id: String?
    var mul: String?
    var type: String?
}
