//
//  KouSuanResultViewController.swift
//  student
//
//  Created by luania on 16/1/4.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit

class KouSuanResultViewController: BaseDialogViewController {
    
    @IBOutlet weak var upLineLabel: UILabel!
    @IBOutlet weak var downLineLabel: UILabel!
    
    var totalNum = 20
    var rightNum = 5
    var wrongNum = 15
    
    var costTime = 10.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUpLine()
        initDownLine()
    }
    
    func initUpLine(){
        let subString = NSAttributedString(string: "共")
        let subString1 = getBlueString(String(totalNum))
        let subString2 = NSAttributedString(string: "题，对")
        let subString3 = getBlueString(String(rightNum))
        let subString4 = NSAttributedString(string: "题，错")
        let subString5 = getBlueString(String(wrongNum))
        let subString6 = NSAttributedString(string: "错")
        
        let upString = NSMutableAttributedString()
        upString.appendAttributedString(subString)
        upString.appendAttributedString(subString1)
        upString.appendAttributedString(subString2)
        upString.appendAttributedString(subString3)
        upString.appendAttributedString(subString4)
        upString.appendAttributedString(subString5)
        upString.appendAttributedString(subString6)
        upLineLabel.attributedText = upString
    }
    
    func initDownLine(){
        let subString = NSMutableAttributedString(string: "答题完成，用时")
        let subString1 = getBlueString(String(costTime))
        let subString2 = NSMutableAttributedString(string: "秒")
        
        
        let downString = NSMutableAttributedString()
        downString.appendAttributedString(subString)
        downString.appendAttributedString(subString1)
        downString.appendAttributedString(subString2)
        downLineLabel.attributedText = downString
    }
    
    func getBlueString(string:String)->NSMutableAttributedString{
        let result = NSMutableAttributedString(string: string)
        let color = QKColor.themeBackgroundColor_1()
        result.addAttribute(NSForegroundColorAttributeName, value:color, range:NSMakeRange(0, string.characters.count) )
        return result
    }
}
