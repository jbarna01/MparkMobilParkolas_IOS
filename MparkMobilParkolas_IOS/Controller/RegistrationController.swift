//
//  RegistrationController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 03. 24..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
    @IBOutlet weak var labelSmsSzoveg: UILabel!
    @IBOutlet weak var txtRegisztraciosKod: UITextField!
    
    let utils = Utils();
    let registrationService = RegistrationService();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtRegisztraciosKod.placeholder = Konst.paceholder.regisztraciosKod;
        labelSmsSzoveg.text = Konst.szoveg.reg_tajekoztato;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnBelepes(_ sender: UIButton) {
//        Leellenőrizzük van-e Internet kapcsolat
//        if Reachability.isConnectedToNetwork() == true {

        // Kiolvassuk a telefonszám mező értékét
        let apiKey = String(describing: self.txtRegisztraciosKod.text!);
            
        let result: String = registrationService.apiKeyEllenorzese(apiKey);
        switch result {
        case "msg_002":
            displayAlertMessage(alertTitle: "Hiba!", userMessage: Konst.info.info_002);
        case "msg_003":
            displayAlertMessage(alertTitle: "Hiba!", userMessage: Konst.info.info_003);
        default:
            apiKeyRegistration(apiKey)
        }
    }
    
    func apiKeyRegistration(_ apiKey: String) {
        let apiKeyResultData = registrationService.checkApiKey(apiKey: apiKey)
        
        switch apiKeyResultData.JSONresult {
        case "OK":
            // Mentjük a regisztrációs adatokat.
            // A regisztrációs számot
            // A visszakapott telefonszámot
            // A regisztráció sikerét (Sikeres = 1)
            let defaults = UserDefaults.standard;
            defaults.set(apiKeyResultData.phoneNumber, forKey: "phoneNumber");
            defaults.set(apiKey, forKey: "apiKey");
            defaults.set(1, forKey: "registration");
            
            // Átírányitjuk a kezdő oldalra
            // A kezdőoldal fog a parkolás indítás oldalra irányítani.
            self.performSegue(withIdentifier: "registrationGoMainView", sender: self );
        case "-1001":
            // Mobil alkalmazás használata nem engedélyezett
            self.txtRegisztraciosKod.text = "";
            displayAlertMessage(alertTitle: "Hiba!", userMessage: Konst.error.err_1001)
        case "-2001":
            // Hibás regisztrációs kód
            self.txtRegisztraciosKod.text = "";
            displayAlertMessage(alertTitle: "Hiba!", userMessage: Konst.error.err_2001)
        case "-2002":
            // Mobil alkalmazás regisztrációja sikertelen
            self.txtRegisztraciosKod.text = "";
            displayAlertMessage(alertTitle: "Hiba!", userMessage: Konst.error.err_2002)
        default:
            // Egyéb hiba
            self.txtRegisztraciosKod.text = "";
            displayAlertMessage(alertTitle: "Hiba!", userMessage: Konst.error.err_9999)
        } // Switch vége
    }
    
    func displayAlertMessage(alertTitle: String, userMessage: String) {
        let myAlert = UIAlertController(title: alertTitle, message: userMessage, preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title:"Ok", style: UIAlertAction.Style.default, handler: nil);
        
        myAlert.addAction(okAction);
        present(myAlert, animated: true, completion: nil);

    }
    
    // Virtuális billentyűzet megjelenítése a text mezőbe történő kattintáskor
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }

}
