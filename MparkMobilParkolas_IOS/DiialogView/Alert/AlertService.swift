//
//  AlertService.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 03..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class AlertService {
    
    func alert(title: String, szoveg: String) -> AlertController {
        
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main);
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertController;
        
        alertVC.alertTitle = title;
        alertVC.alertSzoveg = szoveg;
        
        return alertVC;
    }
}
