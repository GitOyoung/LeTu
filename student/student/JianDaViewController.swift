//
//  JianDaViewController.swift
//  student
//
//  Created by luania on 16/1/11.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit

class JianDaViewController: QuestionBaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PassImageDataDelegate {

    @IBOutlet weak var questionTitleView: QuestionTitleView!
    @IBOutlet weak var questionBodyLabel: UILabel!
    
    @IBOutlet weak var answerTextField: UITextField!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var keyboardButton: UIButton!
    
    @IBOutlet weak var answersView: UIView!
    
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var answerConstraintHeight: NSLayoutConstraint!
    
    var imagePicker:UIImagePickerController!
    var imageUrls:[String] = []
    var appeared = false
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    let http: HttpRequest = HttpRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(questionTitleView)
        setQuestionBody(question)
        initButtons()
    }
    
    func initButtons(){
        initButton(cameraButton)
        initButton(drawButton)
        initButton(keyboardButton)
    }
    
    func initButton(button:UIButton){
        button.layer.cornerRadius = 6
        button.backgroundColor = QKColor.themeBackgroundColor_1()
    }
    
    func setQuestionBody(question:EtaskQuestion?){
        if let question = question {
            questionBodyLabel.text = htmlFormatString(question.questionBody!)
        }
    }
    
    @IBAction func cameraClicked(sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func drawClicked(sender: UIButton) {
        let controller = CanvasViewController()
        controller.delegate = self
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func keyboardClicked(sender: UIButton) {
        if(answerTextField.hidden){
            answerTextField.hidden = false
            answerTextField.becomeFirstResponder()
        }else{
            answerTextField.hidden = true
            answerTextField.resignFirstResponder()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        saveImage(image!)
    }
    
    func passImageData(image: UIImage) {
        saveImage(image)
    }
    
    func saveImage(image:UIImage){
        let imageData:NSData = UIImageJPEGRepresentation(image, 0.5)!
        let tempPath:String = getTempPath()
        imageData.writeToFile(tempPath as String, atomically: false)
        
        http.uploadFile(tempPath) { dic in
            print(dic)
            if((dic["code"] as! String) == "20000"){
                let urls:[String] = dic["data"] as! [String]
                let url = urls[0]
                self.addImageView(url)
                self.loadImages()
            }
        }
    }
    
    func getTempPath() -> String{
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        return NSHomeDirectory().stringByAppendingString("/Documents").stringByAppendingString("/temp\(strNowTime).png")
    }
    
    func addImageView(url:String){
        imageUrls.append(url)
        let view = getAnswerView()
        answersView.addSubview(view)
        contentHeight.constant = contentHeight.constant + 210
        answerConstraintHeight.constant = answerConstraintHeight.constant + 210
    }
    
    func getAnswerView() -> UIView{
        print(answersView.frame.size.width)
        let resultView = UIView(frame: CGRectMake(0, CGFloat(230 * (imageUrls.count-1)), screenWidth-16, 200))
        resultView.addSubview(getImageView())
        resultView.addSubview(getRemoveButton())
        return resultView
    }
    
    func getImageView() -> UIImageView{
        let imageView = UIImageView(frame: CGRectMake(0, 30, screenWidth-16, 200))
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }
    
    func getRemoveButton() -> UIButton{
        let removeButton = UIButton(frame: CGRectMake(screenWidth-16-50,0,50,30))
        removeButton.setTitle("删除", forState: .Normal)
        removeButton.setTitleColor(QKColor.blackColor(), forState: .Normal)
        removeButton.addTarget(self, action: "removeClicked:", forControlEvents: .TouchUpInside)
        return removeButton
    }
    
    func removeClicked(sender:UIButton){
        let imageViews = answersView.subviews
        let index:Int = imageViews.indexOf(sender.superview!)!
        imageUrls.removeAtIndex(index)
        imageViews.last?.removeFromSuperview()
        contentHeight.constant = contentHeight.constant - 210
        answerConstraintHeight.constant = answerConstraintHeight.constant - 210
        loadImages()
    }
    
    func loadImages(){
        let imageViews = answersView.subviews
        for index in 0..<imageViews.count {
            let imageView:UIImageView = (imageViews[index].subviews.first) as! UIImageView
            let url:String = imageUrls[index]
            let nsURL = NSURL(string: url)!
            imageView.setImage(nsURL , placeholdImage: nil)
        }
    }
    
    @IBAction func DidEndOnExit(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    override func updateAnswer() {
        super.updateAnswer()
        var hasTextAnswer:Int = 1
        questionAnswer!.listAnswer.removeAll()
        if(!answerTextField.hidden){
            if let text = answerTextField.text {
                if(!text.isEmpty){
                    let dic = getListAnswerItem(text, answerType: 1, ordinal: 1)
                    hasTextAnswer++
                    questionAnswer!.listAnswer.append(dic)
                }
            }
        }
        for (index,str) in imageUrls.enumerate() {
            let dic = getListAnswerItem(str, answerType: 2, ordinal: index+hasTextAnswer)
            questionAnswer!.listAnswer.append(dic)
        }
        print(questionAnswer?.listAnswer.count)
    }
    
    override func loadWithAnswer() {
        if(appeared){
            return
        }
        if(questionAnswer == nil || questionAnswer?.listAnswer == nil){
            return
        }
        for anAnswer in (questionAnswer?.listAnswer)!{
            var dic = anAnswer as! Dictionary<String,AnyObject>
            if((dic["answerType"] as! Int) == 1){
                answerTextField.hidden = false
                answerTextField.text = dic["answer"] as? String
            } else if((dic["answerType"] as! Int) == 2){
                addImageView(dic["answer"] as! String)
            }
        }
        loadImages()
        appeared = true
    }

    
}








