//
//  runningParkingController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 07..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class RunningParkingController: UIViewController {

    let utils = Utils();
    
    @IBOutlet weak var labelElerhetoEgyenleg: UILabel!
    @IBOutlet weak var labelParkolasiIdo: UILabel!
    @IBOutlet weak var labelFelhasznaltEgyenleg: UILabel!
    @IBOutlet weak var zonaKod: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //utils.tabBarBeallitas(parkolok: false, parkolasom: true, profilom: false)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnFrissites(_ sender: Any) {
    }
    @IBAction func btnLeallitas(_ sender: Any) {
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
