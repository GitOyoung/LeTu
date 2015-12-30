//
//  LianXianView.swift
//  student
//
//  Created by luania on 15/12/25.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit
import Foundation

class LianXianView: UIView {
    let dividerSpace:CGFloat = 16
    let cellWidth:CGFloat = 56
    let cellHeight:CGFloat = 46
    
    private var question:EtaskQuestion?
    private var optionA:[[String: AnyObject]]?
    private var optionB:[[String: AnyObject]]?
    
    private var buttonsA:[UIButton] = []
    private var buttonsB:[UIButton] = []
    
    private var connections = Dictionary<Int,Int>()
    
    func setQuestion(newQuestion:EtaskQuestion?){
        question = newQuestion
        let optionLine = question!.optionLine
        optionA =  (optionLine!["optionA"] as? [[String:AnyObject]])!
        optionB =  (optionLine!["optionB"] as? [[String:AnyObject]])!
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 1000, height: 1000)
    }
    
    func initViews(){
        if(question != nil){
            for index in 0..<optionA!.count{
                let y:CGFloat = CGFloat(index) * (cellHeight+dividerSpace)
                let frame = CGRect(x: 0, y: y, width: cellWidth, height: cellHeight)
                addButton(frame,data: optionA![index],index:index)
            }
            for index in 0..<optionB!.count{
                let x = self.frame.width - cellWidth
                let y = CGFloat(index) * (cellHeight+dividerSpace)
                let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
                addButton(frame,data: optionB![index],index:index)
            }
        }
    }
    
    func addButton(frame: CGRect, data:[String:AnyObject],index:Int){
        let newButton = UIButton(frame: frame)
        newButton.backgroundColor = QKColor.makeColorWithHexString("0080f0", alpha: 1)
        
        let text = data["option"] as! String
        let textLabel = getTextLabel(text,frame: frame)
        
        newButton.addSubview(textLabel)
        
        newButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        newButton.tag = index
        addSubview(newButton)
        if(frame.origin.x == 0){
            buttonsA.append(newButton)
        }else{
            buttonsB.append(newButton)
        }
    }
    
    func getTextLabel(text:String,frame:CGRect) -> UILabel{
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        textLabel.font = UIFont.systemFontOfSize(8)
        let decodedText = text.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedStr = try? NSAttributedString(data: decodedText, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType , NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        textLabel.attributedText = attributedStr
        return textLabel
    }
    
    
    var curButton:UIButton! = nil
    func buttonClicked(button:UIButton){
        print("buttonClicked")
        for(key,value) in connections{
            if((button.tag == key && button.frame.origin.x == 0)
                ||
                (button.tag == value && button.frame.origin.x != 0)){
                    //这个button已经连过线,删掉这条线
                    connections.removeValueForKey(key)
                    reCheckButton(curButton,btn:button)
                    curButton = button
                    setNeedsDisplay()
                    return
            }
        }
        if(curButton == nil || curButton.frame.origin.x ==
            button.frame.origin.x){
                //当还未选中第一个button或者选中的button和原来选中的button在同一列的时候选中点击的button
                reCheckButton(curButton,btn:button)
                curButton = button
        }else{
            if(curButton.frame.origin.x == 0){
                //curButton在左边
                connections[curButton.tag] = button.tag
            }else{
                //button在边
                connections[button.tag] = curButton.tag
            }
            checkOffButton(curButton)
            curButton = nil
            setNeedsDisplay()//通知界面重绘
        }
    }
    
    func reCheckButton(curBtn:UIButton?,btn:UIButton){
        if(curBtn != nil){
            checkOffButton(curBtn!)
        }
        checkOnButton(btn)
    }
    
    func checkOffButton(button:UIButton){
        button.layer.borderWidth = 0
    }
    
    func checkOnButton(button:UIButton){
        button.layer.borderColor = UIColor.redColor().CGColor
        button.layer.borderWidth = 2
    }
    
    var context:CGContextRef!
    override func drawRect(rect: CGRect) {
        if(context == nil){
            context = UIGraphicsGetCurrentContext()
        }
        CGContextSetRGBStrokeColor(context, 1, 0, 0, 1)
        CGContextSetLineWidth(context, 2)
        
        print(connections)
        drawLines(connections)
        CGContextStrokePath(context)
    }
    
    func drawLines(connections:[Int:Int]!){
        for (key,value) in connections{
            var startButton:UIButton? = nil
            var endButton:UIButton? = nil
            for btn in buttonsA{
                if(btn.tag == key){
                    startButton = btn
                    break
                }
            }
            for btn in buttonsB{
                if(btn.tag == value){
                    endButton = btn
                    break
                }
            }
            drawLine(startButton!, view2: endButton!)
        }
    }
    
    func drawLine(view1:UIView,view2:UIView){
        let x1 = view1.frame.origin.x
        let y1 = view1.frame.origin.y
        let w1 = view1.frame.size.width
        let h1 = view1.frame.size.height
        
        let y2 = view2.frame.origin.y
        let h2 = view2.frame.size.height
        
        let startX = x1+w1
        let startY = y1+h1/2
        let endX = view2.frame.origin.x
        let endY = y2+h2/2
        
        CGContextMoveToPoint(context, startX, startY)
        CGContextAddLineToPoint(context, endX, endY)
    }
    
    
}
