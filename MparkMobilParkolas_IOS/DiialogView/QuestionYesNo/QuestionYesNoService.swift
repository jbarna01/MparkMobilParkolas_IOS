//
//  QuestionYesNoService.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 10..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class QuestionYesNoService {
    
    func questionYesNo(title: String, szoveg: String, kilepes: @escaping () -> Void) -> QuestionYesNoController {
        
        let storyboard = UIStoryboard(name: "QuestionYesNoStoryboard", bundle: .main);
        
        let questionYesNoVC = storyboard.instantiateViewController(withIdentifier: "QuestionYesNoVC") as! QuestionYesNoController;
        
        questionYesNoVC.questionTitle = title;
        questionYesNoVC.questionSzoveg  = szoveg;
        questionYesNoVC.btnYesAction = kilepes;
        
        return questionYesNoVC;
    }
}
