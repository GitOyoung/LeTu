//
//  EtaskDetailViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class EtaskDetailViewController: UIViewController,HttpProtocol {
    
    // MARK: properties
    var etask:EtaskModel?
    
    override func viewDidLoad() {

        super.viewDidLoad()
    
        if let etask = self.etask {
          // 获取电子作业详情地址
            let url: String = ServiceApi.getEtaskDetailUrl()
            // 判断是否已经有用户，如果有则发送请求
            if LTConfig.defaultConfig().defaultUser != nil{
        
                let student:Student = LTConfig.defaultConfig().defaultUser!
                
                let params:NSDictionary = ["etaskId":etask.etaskID!, "userId":student.uuid,"classesId":etask.classesId!,"recordId":etask.recordId!,"accessToken":student.accessToken!]
                let http:HttpRequest = HttpRequest()
                
                http.delegate? = self
                
                http.postRequest(url, params: params)
                
            }
            
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///按钮 － 开始做作业
    @IBAction func startEtask(sender: AnyObject) {
        let etaskWorkonVC = EtaskWorkonViewController()
        self.presentViewController(etaskWorkonVC, animated: true, completion: nil)
    }
    
    ///按钮 － 查看已批改作业
    @IBAction func reviewEtask(sender: AnyObject) {
        let etaskWorkonVC = EtaskWorkonViewController()
        self.presentViewController(etaskWorkonVC, animated: true, completion: nil)
    }
    
    ///按钮 － 左上角返回
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didreceiveResult(result: NSDictionary) {
        print("etask detail")
        print(result)
    }
}