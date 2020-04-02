//
//  ParkingController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 03. 31..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class ParkingController: UIViewController {

    @IBOutlet weak var btnParkolok: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[Konst.tabbar.parkolasom] as? UITabBarItem {tabBarItem.isEnabled = false}

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
