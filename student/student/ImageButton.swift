//
//  ImageButton.swift
//  GifImageDemoSwift
//
//  Created by oyoung on 15/12/28.
//  Copyright © 2015年 oyoung. All rights reserved.
//

import UIKit

enum ImageType
{
    case Unknown
    case GIF
    case PNG
    case JPG
    case JPEG
    case BMP
    init(s: String)
    {
        switch s.uppercaseString
        {
        case "GIF":
            self = .GIF
        case "PNG":
            self = .PNG
        case "JPG":
            self = .JPG
        case "BMP":
            self = .BMP
        case "JPEG":
            self = .JPEG
        default:
            self = .Unknown
            
        }
    }
}

class ImageButton: UIControl {
    
    private var imageView: UIImageView
    private var animated: Bool = false
    var animatedImage: UIImage?
    var normalImage: UIImage?
    
    var imageType: ImageType
    
    init(name n: String, withExtension e: String = "png")
    {
        imageType = .Unknown
        imageView = UIImageView(image: normalImage)
        super.init(frame: CGRectZero)
        addSubview(imageView)
        setupImage(name: n, withExtension: e)
        
    }
    
    func setupImage(name n: String, withExtension e: String)
    {
        if e == "gif"
        {
            imageType = .GIF
            animatedImage = UIImage.gifNamed(n)
            normalImage = UIImage.gifImageNamed(n, forIndex: 0)
        }
        else
        {
            imageType = ImageType(s: e)
            animatedImage = nil
            normalImage = UIImage(named: n)
        }
        if isAnimating()
        {
            imageView.image = animatedImage
        }
        else
        {
            imageView.image = normalImage
        }
    }
    
    func isAnimating() ->Bool {
        return animated
    }
    
    func startAnimating()
    {
        animated = true
        if case .GIF = imageType
        {
            imageView.image = animatedImage
        }
        
    }
    
    func stopAnimating()
    {
        animated = false
        if case .GIF = imageType
        {
            imageView.image = normalImage
        }
    }
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: frame)
        imageType = .Unknown
        animatedImage = nil
        normalImage = nil
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
       imageView.frame = bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal class func buttonNamed(name: String, withExtension e: String) -> ImageButton? {
        
        return ImageButton(name: name, withExtension: e)
    }

}
