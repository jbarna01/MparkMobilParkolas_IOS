//
//  runningParkingController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 07..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class RunningParkingController: UIViewController {
    
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
    
    @IBOutlet weak var labelElerhetoEgyenleg: UILabel!
    @IBOutlet weak var labelParkolasiIdo: UILabel!
    @IBOutlet weak var labelFelhasznaltEgyenleg: UILabel!
    @IBOutlet weak var zonaKod: UITextField!
    @IBOutlet weak var btnFrissites: UIButton!
    @IBOutlet weak var btnLeallitas: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        runningParking(apiKey: apiKey, phoneNumber: phoneNumber, parkingId: parkingId);
    }
    
    @IBAction func btnFrissites(_ sender: Any) {
        runningParking(apiKey: apiKey, phoneNumber: phoneNumber, parkingId: parkingId);
    }
    
    @IBAction func btnLeallitas(_ sender: Any) {
        stopParking(apiKey: apiKey, phoneNumber: phoneNumber, parkingId: parkingId);
    }
    
    func runningParking(apiKey: String, phoneNumber: String, parkingId: String) {
        let tabbar = tabBarController as! TabBarController;
        
        // Leellenőrizzük van-e Internet kapcsolat
        if Reachability.isConnectedToNetwork() == true {
            self.phoneNumber = (defaults.string(forKey: "phoneNumber"))!;
            self.apiKey = (defaults.string(forKey: "apiKey"))!;
            self.parkingId = (String)(describing: tabbar.parkingId);
            self.amount = (String)(describing: tabbar.amount);
            
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
                self.dismiss(animated: true, completion: nil)
            // TODO: Vissza kell menni az előző oldalra, mindne hiba esetén
            case "-1002":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1002 );
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil)
            case "-4001":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_4001 );
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil)
            case "-9998":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9998 );
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil)
            default:
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9999 );
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil)
            }
            indikatorLeallitas();
        } else {
            let alertVC = alertService.alert(title: "Nincskapcsolat!", szoveg: Konst.info.info_011 );
            present(alertVC, animated: true);
        }
    }
    
    func stopParking(apiKey: String, phoneNumber: String, parkingId: String) {
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
            case "-1001":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1001 );
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil)
            case "-1002":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1002 );
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil)
            case "-4001":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_4001 );
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil)
            case "-9998":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9998 );
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil)
            default:
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9999 );
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil)
            }
            indikatorLeallitas();
        } else {
            let alertVC = alertService.alert(title: "Nincskapcsolat!", szoveg: Konst.info.info_011 );
            present(alertVC, animated: true);
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
        activityIndicator.style = UIActivityIndicatorView.Style.medium;
        view.addSubview(activityIndicator);
        activityIndicator.startAnimating();
    }
    
    // A várokozást jelző "ikon" indítása
    func indikatorLeallitas() {
        activityIndicator.stopAnimating();
    }
}
