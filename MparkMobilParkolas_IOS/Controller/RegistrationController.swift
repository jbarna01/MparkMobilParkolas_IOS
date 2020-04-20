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
    @IBOutlet weak var btnBelepes: UIButton!
    
    let registrationService = RegistrationService();
    let alertService = AlertService();
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtRegisztraciosKod.placeholder = Konst.paceholder.regisztraciosKod;
        labelSmsSzoveg.text = Konst.szoveg.reg_tajekoztato;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnBelepes(_ sender: UIButton) {
        // Leellenőrizzük van-e Internet kapcsolat
        if Reachability.isConnectedToNetwork() == true {
            
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
        } else {
            let alertVC = alertService.alert(title: "Nincskapcsolat!", szoveg: Konst.info.info_011 );
            present(alertVC, animated: true);
        }
    }
    
    // A regisztrációs kód regisztrációját hajtja végre
    // Sikeres regisztráció esetén menti a regisztrációs számot, és visszaadja a telefonszámot
    func apiKeyRegistration(_ apiKey: String) {
        // Leellenőrizzük van-e Internet kapcsolat
        if Reachability.isConnectedToNetwork() == true {
            
            // Amíg nem töltődnek be az adatok, addig minden képernyő elemet letiltunk.
            itemsEnableDisable(isEnable: false);
            if #available(iOS 13.0, *) {
                indikatorInditasa()
            } else {
                // Fallback on earlier versions
            };
            
            let registrationResponse = registrationService.checkApiKey(apiKey: apiKey)
            
            switch registrationResponse.result {
            case "OK":
                // Mentjük a regisztrációs adatokat.
                // A regisztrációs számot
                // A visszakapott telefonszámot
                // A regisztráció sikerét (Sikeres = 1)
                let defaults = UserDefaults.standard;
                defaults.set(registrationResponse.phone, forKey: "phoneNumber");
                defaults.set(apiKey, forKey: "apiKey");
                defaults.set(1, forKey: "registration");
                
                // Visszaállítjuk a VIEW elemek láthatóságát
                self.itemsEnableDisable(isEnable: true);
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
                // Visszaállítjuk a VIEW elemek láthatóságát
                self.itemsEnableDisable(isEnable: true);
                let alertVC = alertService.alert(title: "Hiba!", szoveg: Konst.error.err_2001)
                present(alertVC, animated: true);
            case "-2002":
                // Mobil alkalmazás regisztrációja sikertelen
                self.txtRegisztraciosKod.text = "";
                // Visszaállítjuk a VIEW elemek láthatóságát
                self.itemsEnableDisable(isEnable: true);
                let alertVC = alertService.alert(title: "Hiba!", szoveg: Konst.error.err_2002)
                present(alertVC, animated: true);
            default:
                // Egyéb hiba
                self.txtRegisztraciosKod.text = "";
                // Visszaállítjuk a VIEW elemek láthatóságát
                self.itemsEnableDisable(isEnable: true);
                let alertVC = alertService.alert(title: "Hiba!", szoveg: Konst.error.err_9999)
                present(alertVC, animated: true);
            } // Switch vége
        } else {
            let alertVC = alertService.alert(title: "Nincskapcsolat!", szoveg: Konst.info.info_011 );
            present(alertVC, animated: true);
        }
    }
    
    // Képernyő elemek engedélyezése/tíltása
    func itemsEnableDisable(isEnable: Bool) {
        self.txtRegisztraciosKod.isEnabled = isEnable;
        self.btnBelepes.isEnabled = isEnable;
    }
    
    // A várokozást jelző "ikon" indítása
    func indikatorInditasa() {
        
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.style = UIActivityIndicatorView.Style.gray;
        view.addSubview(activityIndicator);
        activityIndicator.startAnimating();
    }
    
    // A várokozást jelző "ikon" indítása
    func indikatorLeallitas() {
        activityIndicator.stopAnimating();
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
