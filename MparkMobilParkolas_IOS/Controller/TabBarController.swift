//
//  TabBarController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 01..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var phoneNumber: String = "";
    var aktPlate: String = "";
    var parkingId: String = "";
    var amount: String = "";
    var zoneCodde: String = "";
    
    let parkingService = ParkingService();
    let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Meg kell vizsgálni fut e indított parkolás.
        // Amennyiben nem akkor a Parkolok! eldalra egyébként a Parkolásom oldalra megyünk
        // Ezek függvényében tiljuk a gombokat
        
        if ( self.futParkolas() ) {
            self.selectedIndex = Konst.tabbar.parkolasom;
        } else {
            self.selectedIndex = Konst.tabbar.parkolok;
        }
    }
    
    func futParkolas() -> Bool {
        var phoneNumber: String = "";
        var apiKey: String = "";
        phoneNumber = (defaults.string(forKey: "phoneNumber"))!;
        apiKey = (defaults.string(forKey: "apiKey"))!;
        // Ellenőrizzük, a felhasznnáló adatait. (Rendszám, és, hogy fut-e parkolás)
        let getAccountData = parkingService.getAccountDataGET(phoneNumber: phoneNumber, apiKey: apiKey);
        if getAccountData.parkingId == "-1" {
            return false;
        } else {
            self.amount = getAccountData.amount!;
            defaults.set(getAccountData.parkingId!, forKey: "parkingId");
            return true;
        }
    }
    
    
    func tabBarBeallitas(parkolokBool: Bool, parkolasomBool: Bool, ProfilomBool: Bool) {
        if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[Konst.tabbar.parkolok] as? UITabBarItem {
            tabBarItem.isEnabled = parkolokBool;
        }
        if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[Konst.tabbar.parkolasom] as? UITabBarItem {
            tabBarItem.isEnabled = parkolasomBool;
        }
        if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[Konst.tabbar.profilom] as? UITabBarItem {
            tabBarItem.isEnabled = ProfilomBool;
        }
    }
}
