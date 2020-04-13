//
//  AlertController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 03..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class AlertController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSzoveg: UILabel!
    
    var alertTitle = String();
    var alertSzoveg = String();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setupView();
    }
    
    func setupView() {
        labelTitle.text = alertTitle;
        labelSzoveg.text = alertSzoveg;
    }
    
    @IBAction func btnOk(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
        
    }
}
