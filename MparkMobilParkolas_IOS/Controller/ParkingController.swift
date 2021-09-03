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
    
    var phoneNumber: String = "";
    var parkingId: String = "";
    var apiKey: String = "";
    var isRegistration: Int = 0;
    var isRemmemberZone: Bool = false;
    
    let utils = Utils();
    let parkingService = ParkingService();
    let alertService = AlertService();
    
    let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        tabBarBeallitas(parkolokBool: true, parkolasomBool: false, ProfilomBool: true);
        accountAdatokLekerese();
    }
    
    func accountAdatokLekerese() {
        // Leellenőrizzük van-e Internet kapcsolat
        if Reachability.isConnectedToNetwork() == true {
            // Kiolvassuk a tárolt adatokat
            phoneNumber = (defaults.string(forKey: "phoneNumber"))!;
            apiKey = (defaults.string(forKey: "apiKey"))!;
            isRegistration = (defaults.integer(forKey: "registration"));
            isRemmemberZone = (defaults.bool(forKey: "isRemmemberZone"));

            let tabbar = tabBarController as! TabBarController;
            tabbar.phoneNumber = phoneNumber;

            // Amíg nem töltődnek be az adatok, addig minden képernyő elemet letiltunk.
            itemsEnableDisable(isEnable: false);
            
            
            // Ellenőrizzük, a felhasznnáló adatait. (Rendszám, és, hogy fut-e parkolás)
            let getAccountData = parkingService.getAccountDataGET(phoneNumber: phoneNumber, apiKey: apiKey);

            switch getAccountData.result {
            case "OK":
                tabbar.aktPlate = getAccountData.plate!;
                tabbar.amount = getAccountData.amount!;
                if getAccountData.parkingId != "-1" {
                    // Amennyiben van futó parkolás, úgy a parkingID mentése után átirányítjuk a Parkolásom oldalra.
                    //tabbar.parkingId = getAccountData.parkingId!;
                    defaults.set(getAccountData.parkingId!, forKey: "parkingId");
                    self.tabBarController?.selectedIndex = Konst.tabbar.parkolasom;
                } else {
                    // Megjelenítjük az aktuális rendszámot
                    labelRendszam.text = utils.plateConvert(plate: getAccountData.plate!);
                    // Amennyiben a zóna mentése be lett kapcsolva a mentett zóna számot beállítjuk
                    if isRemmemberZone {
                        if let saveZoneCode = defaults.string(forKey: "storeZone") {
                            txtZonaKod.text = saveZoneCode;
                        }
                    };
                }
                // Visszaállítjuk a VIEW elemek láthatóságát
                self.itemsEnableDisable(isEnable: true);
            case "-1001":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1001 );
                present(alertVC, animated: true);
            case "-1002":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1002 );
                present(alertVC, animated: true);
            case "-1003":
                // TODO: Kezelni kell ezt az eseményt. (Más telefonról indított futó parkolás)
                // Át kell irányítani a rendszám váltáshoz.
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1002 );
                present(alertVC, animated: true);
            case "-9998":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9998 );
                present(alertVC, animated: true);
            default:
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9999 );
                present(alertVC, animated: true);
            }
        } else {
            let alertVC = alertService.alert(title: "Nincskapcsolat!", szoveg: Konst.info.info_011 );
            present(alertVC, animated: true);
        }
    }

    @IBAction func btnInditasTapped(_ sender: Any) {
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
                    
                    let startParkingData = parkingService.startParkinPOST(phoneNumber: phoneNumber, apiKey: apiKey, aktPlate: String(describing: tabbar.aktPlate), zoneCode: zoneCode);
                    
                    switch startParkingData.result {
                    case "OK":
                        // Bár jönnek vissza adatok de nem kell menteni mert a Parkolásom oldalt egyből lekérjük újra parkolási adatokat
                        //tabbar.parkingId = startParkingData.parkingId!;
                        
                        defaults.set(startParkingData.parkingId!, forKey: "parkingId");
                        defaults.set(zoneCode, forKey: "aktZoneKod");
                        if isRemmemberZone {defaults.set(zoneCode, forKey: "storeZone");};
                        self.tabBarController?.selectedIndex = Konst.tabbar.parkolasom;
                    case "-1001":
                        // Mobil alkalmazás használata nem engedélyezett
                        let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1001 );
                        present(alertVC, animated: true);
                    case "-1002":
                        // Nem sikerült lekérdezni a felhasználói adatokat!\n\rKérem próbálja újra!
                        let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1002 );
                        present(alertVC, animated: true);
                    case "-1003":
                        //TODO: Már fut a parkolást
                        //Át kell irányítani, a rendszámváltáshoz.
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
