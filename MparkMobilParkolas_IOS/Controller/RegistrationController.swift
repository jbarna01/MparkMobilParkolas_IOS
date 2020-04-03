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
    let alertService = AlertService();
    
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
            let alertVC = alertService.alert(title: "Hiba!", szoveg: Konst.info.info_002 )
            present(alertVC, animated: true);
        case "msg_003":
            let alertVC = alertService.alert(title: "Hiba!", szoveg: Konst.info.info_003 )
            present(alertVC, animated: true);
        default:
            apiKeyRegistration(apiKey)
        }
    }
    
    func apiKeyRegistration(_ apiKey: String) {
        let apiKeyResultData = registrationService.checkApiKey(apiKey: apiKey)
        
        switch apiKeyResultData.responseData {
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
            self.dismiss(animated: true, completion: nil)
        case "-1001":
            // Mobil alkalmazás használata nem engedélyezett
            self.txtRegisztraciosKod.text = "";
            let alertVC = alertService.alert(title: "Hiba!", szoveg: Konst.error.err_1001)
            present(alertVC, animated: true);
        case "-2001":
            // Hibás regisztrációs kód
            self.txtRegisztraciosKod.text = "";
            let alertVC = alertService.alert(title: "Hiba!", szoveg: Konst.error.err_2001)
            present(alertVC, animated: true);
        case "-2002":
            // Mobil alkalmazás regisztrációja sikertelen
            self.txtRegisztraciosKod.text = "";
            let alertVC = alertService.alert(title: "Hiba!", szoveg: Konst.error.err_2002)
            present(alertVC, animated: true);
        default:
            // Egyéb hiba
            self.txtRegisztraciosKod.text = "";
            let alertVC = alertService.alert(title: "Hiba!", szoveg: Konst.error.err_9999)
            present(alertVC, animated: true);
        } // Switch vége
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
