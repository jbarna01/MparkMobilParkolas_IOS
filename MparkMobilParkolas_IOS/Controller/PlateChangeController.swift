//
//  PlateChangeController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 10..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

protocol PlateChangeControllerDelegata: NSObjectProtocol {
    func doSometthingWith(data: String)
}

class PlateChangeController: UIViewController {
    
    weak var delegate: PlateChangeControllerDelegata?
    @IBOutlet weak var labelAktualisRendszam: UILabel!
    @IBOutlet weak var labelAktPlate: UILabel!
    @IBOutlet weak var labelMentesSzukseges: UILabel!
    @IBOutlet weak var labelFlottaRendszamai: UILabel!
    @IBOutlet weak var plateTableView: UITableView!
    @IBOutlet weak var btnMentes: UIButton!
    @IBOutlet weak var btnVissza: UIButton!
    
    let utils = Utils();
    let alertService = AlertService();
    let plateChangeService = PlateChangeService();
    let defaults = UserDefaults.standard;
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    
    var phoneNumber: String = "";
    var apiKey: String = "";
    var aktPlate: String?;
    var plates = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plateTableView.delegate = self;
        plateTableView.dataSource = self;
        queryPlates();
        self.btnMentes.isEnabled = false;
        labelAktPlate.text = utils.plateConvert(plate: aktPlate!);
        labelFlottaRendszamai.layer.masksToBounds = true;
        labelFlottaRendszamai.layer.cornerRadius = labelFlottaRendszamai.frame.size.height / 2;
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    // Mégse gombot nyomta meg
    @IBAction func btnVisszaTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    // Mentés gombot nyomta meg, menteni kell a kiválasztott rendszámot.
    @IBAction func btnMentesTapped(_ sender: Any) {
        plateChange();
        
    }
    
    func queryPlates() {
        if Reachability.isConnectedToNetwork() == true {
            
            // Kiolvassuk a tárolt adatokat
            phoneNumber = (defaults.string(forKey: "phoneNumber"))!;
            apiKey = (defaults.string(forKey: "apiKey"))!;
            
            // Amíg nem töltődnek be az adatok, addig minden képernyő elemet letiltunk.
            itemsEnableDisable(isEnable: false);
            if #available(iOS 13.0, *) {
                indikatorInditasa()
            } else {
                // Fallback on earlier versions
            };
            
            // Lekérdezzuk az Accounthoz tartozó rendszámokat
            let getAccountPlates = plateChangeService.getAccountPlatesGET(phoneNumber: phoneNumber, apiKey: apiKey);
            
            switch getAccountPlates.result {
            case "OK":
                for plate in getAccountPlates.allPlates! {
                    plates.append(plate.id!)
                }
                // Visszaállítjuk a VIEW elemek láthatóságát
                self.itemsEnableDisable(isEnable: true);
            case "-1001":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1001 );
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil);
            case "-1002":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1002 );
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil);
            case "-9998":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9998 );
                present(alertVC, animated: true);
            //self.dismiss(animated: true, completion: nil);
            case "-9999":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9998 );
                present(alertVC, animated: true);
                //self.dismiss(animated: true, completion: nil);
                self.dismiss(animated: true, completion: nil);
            default:
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9999 );
                present(alertVC, animated: true);
                self.dismiss(animated: true, completion: nil);
            }
            itemsEnableDisable(isEnable: true);
            indikatorLeallitas();
        } else {
            let alertVC = alertService.alert(title: "Nincskapcsolat!", szoveg: Konst.info.info_011 );
            present(alertVC, animated: true);
        }
    }
    
    func plateChange() {
        if Reachability.isConnectedToNetwork() == true {
            // Kiolvassuk a tárolt adatokat
            phoneNumber = (defaults.string(forKey: "phoneNumber"))!;
            apiKey = (defaults.string(forKey: "apiKey"))!;
            
            // Amíg nem töltődnek be az adatok, addig minden képernyő elemet letiltunk.
            itemsEnableDisable(isEnable: false);
            if #available(iOS 13.0, *) {
                indikatorInditasa()
            } else {
                // Fallback on earlier versions
            };
            
            let changePlateResponse = plateChangeService.changeAktPlatePOST(phoneNumber: phoneNumber, apiKey: apiKey, plate: aktPlate!);
            switch changePlateResponse.result {
            case "OK":
                labelAktPlate.text = utils.plateConvert(plate: aktPlate!);
                labelAktualisRendszam.text = "Aktuális rendszám";
                labelMentesSzukseges.text = "";
                if let delegate = delegate {
                    delegate.doSometthingWith(data: aktPlate!);
                }
                self.btnMentes.isEnabled = false;
            case "-1001":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1001 );
                present(alertVC, animated: true);
            case "-1002":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_1002 );
                present(alertVC, animated: true);
            case "-5001":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_5001 );
                present(alertVC, animated: true);
            case "-5002":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_5002 );
                present(alertVC, animated: true);
            case "-9998":
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9998 );
                present(alertVC, animated: true);
            default:
                let alertVC = alertService.alert(title: "Hiba", szoveg: Konst.error.err_9999 );
                present(alertVC, animated: true);
            }
            // Visszaállítjuk a VIEW elemek láthatóságát
            itemsEnableDisable(isEnable: true);
            indikatorLeallitas();
        } else {
            let alertVC = alertService.alert(title: "Nincskapcsolat!", szoveg: Konst.info.info_011 );
            present(alertVC, animated: true);
        }
    }
    
    // Képernyő elemek engedélyezése/tíltása
    func itemsEnableDisable(isEnable: Bool) {
        self.btnVissza.isEnabled = isEnable;
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


extension PlateChangeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plates.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = plateTableView.dequeueReusableCell(withIdentifier: Konst.identifier.onePlateCell, for: indexPath)
        
        cell.textLabel?.text = utils.plateConvert(plate: plates[indexPath.row]);
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 20)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.textLabel?.textColor = UIColor(red: 56.0/255.0, green: 85.0/255.0, blue: 112.0/255.0, alpha: 1);
        cell.textLabel?.textAlignment = NSTextAlignment.center;
        cell.textLabel?.layer.masksToBounds = true;
        cell.textLabel?.layer.cornerRadius = 20;
        return cell;
    }
}

extension PlateChangeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        aktPlate = plates[indexPath.row];
        labelAktPlate.text = utils.plateConvert(plate: aktPlate!);
        labelAktualisRendszam.text = "A Kiválasztott rendszám";
        labelMentesSzukseges.text = "(mentés szükséges)";
        self.btnMentes.isEnabled = true;
    }
}
