//
//  ViewController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 03. 23..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let alertService = AlertService();
    
    override func viewDidLoad() {
        if (!Reachability.isConnectedToNetwork()) {
            let alertVC = alertService.alert(title: "Hiba!", szoveg: Konst.info.info_011)
            present(alertVC, animated: true);
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {

        if (Reachability.isConnectedToNetwork()) {
            let defaults = UserDefaults.standard;
            let isRegistration = defaults.integer(forKey: "registration");

        // Megnézzük, hogy a készülék regisztrált-e. isRegistration = 1 regisztrált készülék esetén.
        if isRegistration != 1 {
            self.performSegue(withIdentifier: Konst.kapcsolatok.startToRegistration, sender: self);
            } else {
            self.performSegue(withIdentifier: Konst.kapcsolatok.startToParking, sender: self);
            }
        } else {
            let alertVC = alertService.alert(title: "Hiba!", szoveg: Konst.info.info_011)
            present(alertVC, animated: true);
        }

    }

    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
}

