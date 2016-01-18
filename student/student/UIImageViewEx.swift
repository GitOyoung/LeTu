//
//  UIImageViewEx.swift
//  student
//
//  Created by oyoung on 16/1/18.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(url: NSURL, placeholdImage pi: UIImage?) {
        self.image = pi
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            if let data = NSData(contentsOfURL: url) {
                let image = UIImage(data: data)
                dispatch_async(dispatch_get_main_queue()){
                    self.image = image
                }
            }
        }
    }
}
