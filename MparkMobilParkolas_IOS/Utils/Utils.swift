//
//  Utils.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 03. 24..
//  Copyright © 2020. BJ. All rights reserved.
//

class Utils {
    
    // Rendszám átalakítás ABC123-ról ABC - 123   -ra
    func plateConvert(plate plateString: String) -> String {
        var convertPlate: String = "";
    
        if plateString != "" {
            //let aktPlateABC: String = (plateString.substring(to: (plateString.index(plateString.startIndex, offsetBy: 3))))
    
            let aktPlateABC = plateString[plateString.startIndex..<plateString.index(plateString.startIndex, offsetBy: 3)]
            let aktPlateNumber = plateString[plateString.index(plateString.startIndex, offsetBy: 3)...]
            convertPlate = (aktPlateABC + " - " + aktPlateNumber);
        } else {
            convertPlate = "AAA - 111"
        }
        return convertPlate;
    }

    // Átalakítjuk a telefonszámot és úgy írjuk ki
    func phoneNumberConvert(phoneNumber phoneNumberString: String) -> String {
       var convertPhoneNumber: String = "";
       
       if phoneNumberString != "" {
           let phoneNumberZone = phoneNumberString[phoneNumberString.index(phoneNumberString.startIndex, offsetBy: 2)...phoneNumberString.index(phoneNumberString.startIndex, offsetBy: 3)]
       
           let phoneNumber123 = phoneNumberString[phoneNumberString.index(phoneNumberString.startIndex, offsetBy: 4)...phoneNumberString.index(phoneNumberString.startIndex, offsetBy: 6)]
       
           let phoneNumber4567 = phoneNumberString[phoneNumberString.index(phoneNumberString.startIndex, offsetBy: 7)...phoneNumberString.index(phoneNumberString.startIndex, offsetBy: 10)]
           convertPhoneNumber = ("(06) " + phoneNumberZone + "/" + phoneNumber123 + "-" + phoneNumber4567);
       } else {
           convertPhoneNumber = "06 30/123-4567"
       }
        return convertPhoneNumber
    }

}
