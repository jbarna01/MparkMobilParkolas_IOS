//
//  AlertPopupController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 02..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

protocol PopupDeleget {
    func closeTapped();
}

class AlertPopupController: UIViewController {

    var closePopup: PopupDeleget?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func btnBezar(_ sender: Any) {
        
        self.closePopup?.closeTapped();
        
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
