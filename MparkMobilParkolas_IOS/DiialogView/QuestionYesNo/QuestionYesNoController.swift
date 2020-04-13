//
//  QuestionYesNoController.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 09..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class QuestionYesNoController: UIViewController {

   
    @IBOutlet weak var labelQuestionTitle: UILabel!
    @IBOutlet weak var labelQuestionSzoveg: UILabel!
    
    var questionTitle = String();
    var questionSzoveg = String();
    var btnYesAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        settupView();

        // Do any additional setup after loading the view.
    }
    
    func settupView() {
        labelQuestionTitle.text = questionTitle;
        labelQuestionSzoveg.text = questionSzoveg;
    }
    
    @IBAction func btnYesTapped(_ sender: Any) {
        dismiss(animated: true);
        btnYesAction?();
    }
    
    @IBAction func btnNoTapped(_ sender: Any) {
        dismiss(animated: true);
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
