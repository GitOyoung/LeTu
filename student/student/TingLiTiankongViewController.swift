//
//  TingLiTiankongViewController.swift
//  student
//
//  Created by zjueman on 15/12/27.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class TingLiTiankongViewController: QuestionBaseViewController {

    @IBOutlet weak var speechLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSpeech(question)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func setSpeech(question:EtaskQuestion?){
        if let question = question {
            if let speechUrlHtmlData = question.speechUrlHtmlData {
                let url = speechUrlHtmlData.dataUsingEncoding(NSUTF8StringEncoding)!
                let attributedStr = try? NSAttributedString(data: url, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType , NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
                speechLabel.attributedText = attributedStr
            }
        }
    }


}
