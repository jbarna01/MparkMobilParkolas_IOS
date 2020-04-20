//
//  runningParkingController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 07..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class RunningParkingController: UIViewController {
    @IBOutlet weak var labelElerhetoEgyenleg: UILabel!
    @IBOutlet weak var labelParkolasiIdo: UILabel!
    @IBOutlet weak var labelFelhasznaltEgyenleg: UILabel!
    @IBOutlet weak var zonaKod: UITextField!
    @IBOutlet weak var btnFrissites: UIButton!
    @IBOutlet weak var btnLeallitas: UIButton!
    
    var phoneNumber: String = "";
    var apiKey: String = "";
    var parkingId = String();
    var parkingPlate = String();
    var amount = String();
    
    let utils = Utils();
    let alertService = AlertService();
    let runningParkingServicer = RunningParkingServices();
    let defaults = UserDefaults.standard;
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();

    override func viewDidLoad() {
        super.viewDidLoad();
        tabBarBeallitas(parkolokBool: false, parkolasomBool: true, ProfilomBool: false);
        runningParking();
    }
    
    @IBAction func btnFrissites(_ sender: Any) {
        runningParking();
    }
    
    @IBAction func btnLeallitas(_ sender: Any) {
        stopParking();
    }
    
    func runningParking() {
        let tabbar = tabBarController as! TabBarController;
        
        // Leellenőrizzük van-e Internet kapcsolat
        if Reachability.isConnectedToNetwork() == true {
            phoneNumber = (defaults.string(forKey: "phoneNumber"))!;
            apiKey = (defaults.string(forKey: "apiKey"))!;
            parkingId = (String)(describing: tabbar.parkingId);
            amount = (String)(describing: tabbar.amount);
            
            // Amíg nem töltődnek be az adatok, addig minden képernyő elemet letiltunk.
            itemsEnableDisable(isEnable: false);
            indikatorInditasa();
            
            // Ellenőrizzük, a felhasznnáló adatait. (Rendszám, és, hogy fut-e parkolás)
            let runningParkingData = runningParkingServicer.runningParkingGet(apiKey: apiKey, phoneNumber: phoneNumber, parkingId: parkingId);
            
            switch runningParkingData.result {
            case "OK":
                labelElerhetoEgyenleg.text = amount == "-1" ? "" : amount;
                labelParkolasiIdo.text = utils.parkolasiIdoKiszamolasa(date: runningParkingData.start!)
                labelFelhasznaltEgyenleg.text = runningParkingData.zoneCost! + " FT";
                
                // Visszaállítjuk a VIEW elemek láthatóságát
                self.itemsEnableDisable(isEnable: true);
            case "-1001":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1001 );
                present(alertVC, animated: true);
            case "-1002":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1002 );
                present(alertVC, animated: true);
            case "-3004":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_3004 );
                present(alertVC, animated: true);
            case "-4001":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_4001 );
                present(alertVC, animated: true);
            case "-9998":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9998 );
                present(alertVC, animated: true);
            default:
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9999 );
                present(alertVC, animated: true);
            }
            itemsEnableDisable(isEnable: true);
            indikatorLeallitas();
        } else {
            let alertVC = alertService.alert(title: "Nincskapcsolat!", szoveg: Konst.info.info_011 );
            present(alertVC, animated: true);
        }
    }
    
    func stopParking() {
        let tabbar = tabBarController as! TabBarController;
        
        // Leellenőrizzük van-e Internet kapcsolat
        if Reachability.isConnectedToNetwork() == true {
            self.phoneNumber = (defaults.string(forKey: "phoneNumber"))!;
            self.apiKey = (defaults.string(forKey: "apiKey"))!;
            self.parkingId = (String)(describing: tabbar.parkingId);
            
            // Amíg nem töltődnek be az adatok, addig minden képernyő elemet letiltunk.
            itemsEnableDisable(isEnable: false);
            indikatorInditasa();
            
            // Ellenőrizzük, a felhasznnáló adatait. (Rendszám, és, hogy fut-e parkolás)
            let stopParkingData = runningParkingServicer.stopParkingGET(apiKey: apiKey, phoneNumber: phoneNumber, parkingId: parkingId);
            
            switch stopParkingData.result {
            case "OK":
                // Visszaállítjuk a VIEW elemek láthatóságát
                self.itemsEnableDisable(isEnable: true);
                let alertVC = alertService.alert(title: "Információ", szoveg: Konst.info.info_012);
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil);
            case "-1001":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1001 );
                present(alertVC, animated: true);
            case "-1002":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1002 );
                present(alertVC, animated: true);
            case "-4001":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_4001 );
                present(alertVC, animated: true);
            case "-9998":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9998 );
                present(alertVC, animated: true);
            default:
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9999 );
                present(alertVC, animated: true);
            }
            self.itemsEnableDisable(isEnable: true);
            indikatorLeallitas();
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
        self.btnFrissites.isEnabled = isEnable;
        self.btnLeallitas.isEnabled = isEnable;
    }
    
    // A várokozást jelző "ikon" indítása
    func indikatorInditasa() {
        
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
        };
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
