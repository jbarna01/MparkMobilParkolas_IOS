//
//  ParkingController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 03. 31..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class ParkingController: UIViewController {

    @IBOutlet weak var labelRendszam: UILabel!
    @IBOutlet weak var txtZonaKod: UITextField!
    @IBOutlet weak var btnParkolasIndatasa: UIButton!
    @IBOutlet weak var btnParkolok: UITabBarItem!
    
    let utils = Utils();
    let parkingService = ParkingService();
    let alertService = AlertService();
    
    var phoneNumber: String = "";
    var parkingId: String = "";
    var apiKey: String = "";
    var isRegistration: Int = 0;
    var isRemmemberZone: Bool = false;
    var aktPlate = "";
    let defaults = UserDefaults.standard;
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[Konst.tabbar.parkolasom] as? UITabBarItem {tabBarItem.isEnabled = false}
        
        tabBarBeallitas(parkolokBool: true, parkolasomBool: false, ProfilomBool: true)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() == true {
            // Kiolvassuk a tárolt adatokat
            phoneNumber = (defaults.string(forKey: "phoneNumber"))!;
            apiKey = (defaults.string(forKey: "apiKey"))!;
            isRegistration = (defaults.integer(forKey: "registration"));
            isRemmemberZone = (defaults.bool(forKey: "isRemmemberZone"));

            let tabbar = tabBarController as! TabBarController;
            tabbar.phoneNumber = phoneNumber;
            
            // TODO: Innen fgv-be szervezni.
            // Amíg nem töltődnek be az adatok, addig minden képernyő elemet letiltunk.
            itemsEnableDisable(isEnable: false);
         
            // Ellenőrizzük, a felhasznnáló adatait. (Rendszám, és, hogy fut-e parkolás)
            indikatorInditasa();
            
            let getAccountData = parkingService.getAccountDataGET(phoneNumber: phoneNumber, apiKey: apiKey);
            switch getAccountData.responseData {
            case "OK":
                let tabbar = tabBarController as! TabBarController;
                tabbar.aktPlate = getAccountData.plate;
                if getAccountData.parkingId != "-1" {
                    self.tabBarController?.selectedIndex = Konst.tabbar.parkolasom;
                } else {
                    aktPlate = utils.plateConvert(plate: getAccountData.plate);
                    labelRendszam.text = aktPlate;
                }
                if isRemmemberZone {
                    if let saveZoneCode = defaults.string(forKey: "storeZone") {
                        txtZonaKod.text = saveZoneCode;
                    }
                };
                // Visszaállítjuk a VIEW elemek láthatóságát
                self.itemsEnableDisable(isEnable: true);
            case "-1001":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1001 );
                present(alertVC, animated: true);
            case "-1002":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1002 );
                present(alertVC, animated: true);
            case "-1003":
                // TODO: Kezelni kell ezt az eseményt
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1002 );
                present(alertVC, animated: true);
            case "-9998":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9998 );
                present(alertVC, animated: true);
            default:
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9999 );
                present(alertVC, animated: true);
            }
            indikatorLeallitas();
        } else {
            let alertVC = alertService.alert(title: "Nincskapcsolat!", szoveg: Konst.info.info_011 );
            present(alertVC, animated: true);
        }
    }

    @IBAction func btnTapped(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
            let zoneCode: String = txtZonaKod.text!;
            if (zoneCode.isEmpty) {
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.info.info_005 );
                present(alertVC, animated: true);
            } else {
                // Le kell ellenőrizni a hosszát is!
                if zoneCode.count != 4 {
                    let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.info.info_006 );
                    present(alertVC, animated: true);
                } else {
                    // Kiolvassuk a rendszámot
                    let tabbar = tabBarController as! TabBarController;
                    // Amíg nem töltődnek be az adatok, addig minden képernyő elemet letiltunk.
                    itemsEnableDisable(isEnable: false);
                    print(String(describing: tabbar.aktPlate))
                    let startParkingData = parkingService.startParkinPOST(phoneNumber: phoneNumber, apiKey: apiKey, aktPlate: String(describing: tabbar.aktPlate), zoneCode: zoneCode);
                    switch startParkingData.responseData {
                    case "-1002":
                        if isRemmemberZone {defaults.set(zoneCode, forKey: "storeZone");};
                        
                        //TODO: Át kell irányítani a parkolok oldalra, de előtte be kell állítani számos adatot.
                        self.tabBarController?.selectedIndex = Konst.tabbar.profilom;
                    case "-1001":
                        // Mobil alkalmazás használata nem engedélyezett
                        let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1001 );
                        present(alertVC, animated: true);
                    case "-10002":
                        // Nem sikerült lekérdezni a felhasználói adatokat!\n\rKérem próbálja újra!
                        let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1002 );
                        present(alertVC, animated: true);
                    case "-1003":
                        //TODO: Már fut a parkoláas
                        let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.msg_1003 );
                        present(alertVC, animated: true);
                    case "-3001":
                        // Nincs elég egyenlege!
                        let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_3001 );
                        present(alertVC, animated: true);
                    case "-3002":
                        // Hibás ZÓNA kód!
                        let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_3002 );
                        present(alertVC, animated: true);
                    case "-3003":
                        // Nem sikerült a parkolást elindítani!
                        let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_3003 );
                        present(alertVC, animated: true);
                    case "-9998":
                        // Időtúllépés!
                        let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9998 );
                        present(alertVC, animated: true);
                    default:
                        let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9999 );
                        present(alertVC, animated: true);
                    }
                    // Engedélyezzük a képernyő elemeket
                    itemsEnableDisable(isEnable: true);
                }
            }
        } else {
            let alertVC = alertService.alert(title: "Nincskapcsolat!", szoveg: Konst.info.info_011 );
            present(alertVC, animated: true);
        }
    }
    
    func tabBarBeallitas(parkolokBool: Bool, parkolasomBool: Bool, ProfilomBool: Bool) {
        if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[Konst.tabbar.parkolok] as? UITabBarItem {
            tabBarItem.isEnabled = parkolokBool;
        }
        if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[Konst.tabbar.parkolasom] as? UITabBarItem {
            tabBarItem.isEnabled = parkolasomBool;
        }
        if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[Konst.tabbar.profilom] as? UITabBarItem {
            tabBarItem.isEnabled = ProfilomBool;
        }
    }
    
   // Képernyő elemek engedélyezése/tíltása
   func itemsEnableDisable(isEnable: Bool) {
           self.txtZonaKod.isEnabled = isEnable;
           self.btnParkolasIndatasa.isEnabled = isEnable;
   }

    // A várokozást jelző "ikon" indítása
    func indikatorInditasa() {
        
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.style = UIActivityIndicatorView.Style.medium;
        view.addSubview(activityIndicator);
        activityIndicator.startAnimating();
    }
    
    // A várokozást jelző "ikon" indítása
    func indikatorLeallitas() {
        activityIndicator.stopAnimating();
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
