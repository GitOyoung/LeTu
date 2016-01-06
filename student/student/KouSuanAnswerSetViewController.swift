//
//  KouSuanAnswerSetViewController.swift
//  student
//
//  Created by luania on 15/12/30.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

enum KouSuanAnswerWay{
    case keyboard
    case speak
}

class KouSuanAnswerSetViewController: BaseDialogViewController {
    
    var delegate:passAnswerSetDataDelegate!
    
    @IBOutlet weak var keyboardButton: UIButton!
    @IBOutlet weak var speakButton: UIButton!
    
    @IBOutlet weak var timersView: UIView!
    @IBOutlet weak var threeSecondButton: UIButton!
    @IBOutlet weak var fiveSecondButton: UIButton!
    @IBOutlet weak var sevenSecondButton: UIButton!
    @IBOutlet weak var manualButton: UIButton!
    var timerButtons:[UIButton]! = [UIButton]()
    
    var selWay = KouSuanAnswerWay.keyboard
    var selTimer:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initButton(keyboardButton,checked: true)
        initButton(speakButton,checked: false)
        
        initButton(threeSecondButton, checked: true)
        threeSecondButton.tag = 3
        initButton(fiveSecondButton, checked: false)
        fiveSecondButton.tag = 5
        initButton(sevenSecondButton, checked: false)
        sevenSecondButton.tag = 7
        initButton(manualButton, checked: false)
        manualButton.tag = 0
        
        timerButtons.append(threeSecondButton)
        timerButtons.append(fiveSecondButton)
        timerButtons.append(sevenSecondButton)
        timerButtons.append(manualButton)
        
        selTimer = threeSecondButton.tag
    }
    
    func initButton(button:UIButton,checked:Bool){
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = QKColor.themeBackgroundColor_1().CGColor
        if(checked){
            button.backgroundColor = QKColor.themeBackgroundColor_1()
            button.setTitleColor(QKColor.whiteColor(), forState: UIControlState.Normal)
        }
        else{
            button.backgroundColor = QKColor.whiteColor()
            button.setTitleColor(QKColor.themeBackgroundColor_1(), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func keyboardButtonClicked(sender: UIButton) {
        checkOnButton(keyboardButton)
        checkOffButton(speakButton)
        selWay = KouSuanAnswerWay.keyboard
        timersView.hidden = true
    }
    
    @IBAction func speakButtonClicked(sender: UIButton) {
        checkOnButton(speakButton)
        checkOffButton(keyboardButton)
        selWay = KouSuanAnswerWay.speak
        timersView.hidden = false
    }
    
    @IBAction func timerButtonClicked(sender: UIButton) {
        for button in timerButtons{
            if(button == sender){
                checkOnButton(button)
                selTimer = button.tag
            }else{
                checkOffButton(button)
            }
        }
    }
    
    func checkOnButton(button:UIButton){
        button.backgroundColor = QKColor.themeBackgroundColor_1()
        button.setTitleColor(QKColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    func checkOffButton(button:UIButton){
        button.backgroundColor = QKColor.whiteColor()
        button.setTitleColor(QKColor.themeBackgroundColor_1(), forState: UIControlState.Normal)
    }
    
    @IBAction func confirmButtonClicked(sender: UIButton) {
        print("confirm")
        dismissViewControllerAnimated(true , completion: nil)
        delegate.passAnswerSetData(selWay, answerTimer: selTimer)
    }
    
    @IBAction func cancelButtonClicked(sender: UIButton) {
        dismissViewControllerAnimated(true , completion: nil)
    }
    
}
