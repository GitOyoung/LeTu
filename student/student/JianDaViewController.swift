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
            let urls:[String] = dic["data"] as! [String]
            let url = urls[0]
            self.addImage(url)
        }
    }
    
    func getTempPath() -> String{
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        return NSHomeDirectory().stringByAppendingString("/Documents").stringByAppendingString("/temp\(strNowTime).png")
    }
    
    func addImage(url:String){
        imageUrls.append(url)
        let view = getAnswerView()
        answersView.addSubview(view)
        loadImages()
        contentHeight.constant = contentHeight.constant + 210
        answerConstraintHeight.constant = answerConstraintHeight.constant + 210
    }
    
    func getAnswerView() -> UIView{
        let resultView = UIView(frame: CGRectMake(0, CGFloat(230 * (imageUrls.count-1)), answersView.frame.size.width, 200))
        resultView.addSubview(getImageView())
        resultView.addSubview(getRemoveButton())
        return resultView
    }
    
    func getImageView() -> UIImageView{
        let imageView = UIImageView(frame: CGRectMake(0, 30, answersView.frame.size.width, 200))
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }
    
    func getRemoveButton() -> UIButton{
        let removeButton = UIButton(frame: CGRectMake(answersView.frame.size.width-50,0,50,30))
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
    
}








