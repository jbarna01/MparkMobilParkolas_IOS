//
//  profilomController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 07..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class ProfilomController: UIViewController, PlateChangeControllerDelegata {
    
    @IBOutlet weak var btnChangePlate: UIButton!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var zoneOn: UISwitch!
    @IBOutlet weak var labelZone: UILabel!
    
    let questionYesNoService = QuestionYesNoService();
    let utils = Utils();
    let defaults = UserDefaults.standard;
    
    var changePlate: String?;
    var isRemmemberZone: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tabbar = tabBarController as! TabBarController;
        btnChangePlate.setTitle(utils.plateConvert(plate: String(describing: tabbar.aktPlate)), for: .normal)
        labelPhoneNumber.text = utils.phoneNumberConvert(phoneNumber: String(describing: tabbar.phoneNumber));
        zoneSwitchBeallitasa();
    }
    
    func zoneSwitchBeallitasa() {
        // Ellenőrizük, hogy be lett-e kapcsolva a zone mentése funkció
        isRemmemberZone = (defaults.bool(forKey: "isRemmemberZone"));
        if isRemmemberZone {
            zoneOn.setOn(true, animated: true);
            labelZone.textColor = UIColor(red: 0.980, green: 0.211, blue: 0.019, alpha: 1.0);
        } else {
            zoneOn.setOn(false, animated: true);
            labelZone.textColor = UIColor.lightGray;
        }
    }
    
    
    @IBAction func zoneOnTapped(_ sender: Any) {
        if zoneOn.isOn {
            defaults.set(true, forKey: "isRemmemberZone");
            labelZone.textColor = UIColor(red: 0.980, green: 0.211, blue: 0.019, alpha: 1.0);
        } else {
            defaults.set(false, forKey: "isRemmemberZone");
            labelZone.textColor = UIColor.lightGray;
        }
    }
    
    @IBAction func btnPlateChangeTapped(_ sender: Any) {
        self.performSegue(withIdentifier: Konst.kapcsolatok.rendszamValatas, sender: self)
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        let questionYesNoVc = questionYesNoService.questionYesNo(title: "Figyelmeztetés", szoveg: "Bíztos ki akarsz lépni.") {
            self.defaults.removeObject(forKey: "phoneNumber");
            self.defaults.removeObject(forKey: "apiKey");
            self.defaults.removeObject(forKey: "registration");
            // Átírányitjuk a kezdő oldalra
            self.dismiss(animated: true, completion: nil);
        }
        present(questionYesNoVc, animated: true);
    }
    
    
    override func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        if seque.identifier == "rendszamValatas" {
            let tabbar = tabBarController as! TabBarController;
            let plateChangeVC = seque.destination as! PlateChangeController;
            plateChangeVC.delegate = self;
            plateChangeVC.aktPlate = String(describing: tabbar.aktPlate);
        }
    }
    
    func doSometthingWith(data: String) {
        btnChangePlate.setTitle(utils.plateConvert(plate: String(describing: data)), for: .normal);
        let tabbar = tabBarController as! TabBarController;
        tabbar.aktPlate = data;
    }
    
}
