//
//  ViewController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 03. 23..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        if (!Reachability.isConnectedToNetwork()) {
            self.displayAlertMessage(alertTitle: Konst.title.nincsKapcsolat, userMessage: Konst.info.info_011);
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
        if isRegistration == 1 {
            self.performSegue(withIdentifier: Konst.kapcsolatok.startToRegistration, sender: self);
            } else {
            self.performSegue(withIdentifier: Konst.kapcsolatok.startToParking, sender: self);
            }
        } else {
    self.displayAlertMessage(alertTitle: Konst.info.info_010, userMessage: Konst.info.info_011);
        }

    }
    
    func displayAlertMessage(alertTitle: String, userMessage: String) {
        let myAlert = UIAlertController(title: alertTitle, message: userMessage, preferredStyle: UIAlertController.Style.alert);

        let okAction = UIAlertAction(title:"Ok", style: UIAlertAction.Style.default, handler: nil);

        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);

    }

    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
}

