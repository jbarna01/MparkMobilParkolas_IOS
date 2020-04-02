//
//  TabBarController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 01..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Meg kell vizsgálni fut e indított parkolás.
        // Amennyiben nem akkor a Parkolok! eldalra egyébként a Parkolásom oldalra megyünk
        // Ezek függvényében tiljuk a gombokat
        
        if ( self.futParkolas() ) {
            if let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[Konst.tabbar.parkolok] as? UITabBarItem {
                tabBarItem.isEnabled = false;
            }
            if let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[Konst.tabbar.profilom] as? UITabBarItem {
                tabBarItem.isEnabled = false;
            }
            self.selectedIndex = Konst.tabbar.parkolasom;
        } else {
            if let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[Konst.tabbar.parkolasom] as? UITabBarItem {
                tabBarItem.isEnabled = false;
            }
            self.selectedIndex = Konst.tabbar.parkolok;
        }
    }
    
    func futParkolas() -> Bool {
        return false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
