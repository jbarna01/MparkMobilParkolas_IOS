//
//  AccountPlates.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 12..
//  Copyright © 2020. BJ. All rights reserved.
//

import Foundation

struct AccountPlatesResponse: Decodable {
    var result: String
    var allPlates: [AllPlates]?
}
struct AllPlates: Decodable{
        var id: String?
        var mul: String?
        var type: String?
    }
