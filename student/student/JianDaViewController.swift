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
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var speakButton: UIButton!
    @IBOutlet weak var keyboardButton: UIButton!
    
    @IBOutlet weak var answersView: UIView!
    
    var imagePicker:UIImagePickerController!
    var images:[UIImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(questionTitleView)
        setQuestionBody(question)
        initButtons()
    }
    
    func initButtons(){
        initButton(cameraButton)
        initButton(drawButton)
        initButton(speakButton)
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        createImageView(image!)
    }
    
    func passImageData(image: UIImage) {
        createImageView(image)
    }
    
    func createImageView(image:UIImage){
        let imageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        imageView.image = image
        imageView.contentMode = .ScaleAspectFill
        answersView.addSubview(imageView)
    }
}
