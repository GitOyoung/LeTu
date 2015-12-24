//
//  MeAfterLoginViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class MeAfterLoginViewController: UIViewController {
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.cornerRadius = 6
        nameButton.layer.borderColor = UIColor.whiteColor().CGColor
        nameButton.layer.borderWidth = 1
        nameButton.layer.cornerRadius = 6
        headImageView.layer.cornerRadius = 40.5
    }
    
    override func viewDidAppear(animated: Bool) {
        loadUserData()
    }
    
    @IBAction func nameTouchUpInside(sender: UIButton) {
        presentViewController(MeLoginViewController(), animated: true, completion: nil)
    }
    
    func loadUserData(){
        let user:UserModel? = NSUserDefaultUtil.getUser()
        if(user == nil){
            headImageView.image = nil
            nameButton.setTitle("登录", forState: UIControlState.Normal)
            nameButton.enabled = true
            schoolLabel.text = nil
            subjectLabel.text = nil
        }else{
            //            let imageUrlString = user?.imgUrl
            let imageUrlString = "https://www.baidu.com/img/bd_logo1.png"
            let imageURL = NSURL(string:imageUrlString)!
            let imageData = NSData(contentsOfURL: imageURL)
            if(imageData != nil){
                headImageView.image = UIImage(data: imageData!)
            }
            nameButton.setTitle(user?.name, forState: UIControlState.Normal)
            nameButton.enabled = false
            schoolLabel.text = user?.school
            subjectLabel.text = ""//TODO
        }
    }
    
}





