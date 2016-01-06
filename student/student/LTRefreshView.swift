//
//  LTRefreshView.swift
//  student
//
//  Created by oyoung on 16/1/5.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit

enum LTRefreshState : Int
{
    case Normal = 0
    case WillRefresh = 1
    case Refreshing = 2
    case Refreshed = 3
}

enum LTRefreshStyle
{
    case PullDown
    case PullUp
}


public struct RefreshContentScale
{
    var sx: CGFloat = 1
    var sy: CGFloat = 1
    init(sx: CGFloat, sy: CGFloat) {
        self.sx = sx
        self.sy = sy
    }
}

public class LTRefreshView: UIView {

    public static var REFRESH_HEADER_HEIGHT: CGFloat = 52

    
    var refreshing: Bool  = false
    var state: LTRefreshState = .Normal
    var delegate: LTRefreshViewDelegate?
    
    var tips: [String] = ["上拉加载更多","松开加载","正在加载中...","加载完成"]
    
    
    var refreshLabel: UILabel!
    var refreshArrow: UIImageView!
    var refreshSpinner: UIActivityIndicatorView!
    
    var contentScale: RefreshContentScale = RefreshContentScale(sx: 1.0, sy: 1.0)
    var contentView: UIView? {
        willSet {
            contentView?.removeFromSuperview()
        }
    }
    
    
    private func layoutContentView() {
        var frame = bounds
        frame.size.width *= contentScale.sx
        frame.size.height *= contentScale.sy
        contentView?.frame = frame
        contentView?.center = center
        frame = (contentView?.bounds)!
        refreshLabel.frame = frame
        refreshArrow.frame = CGRect(x: (frame.height - 27) / 2, y: (frame.height - 44) / 2, width: 27, height: 44)
        refreshSpinner.frame = CGRect(x: (frame.height - 20) / 2, y: (frame.height - 20) / 2, width: 20, height: 20)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutContentView()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        LTRefreshView.REFRESH_HEADER_HEIGHT = frame.height
        setupContentView()
    }
    
   
    
    private func setupContentView() {
        var frame = bounds
        frame.size.height *= contentScale.sy
        frame.size.width *= contentScale.sx
        let view = UIView(frame: frame)
        view.center = center
        contentView = view
        
        //
        refreshLabel = UILabel(frame: view.bounds)
        refreshLabel.backgroundColor = UIColor.clearColor()
        refreshLabel.font = UIFont.boldSystemFontOfSize(14.0)
        refreshLabel.textAlignment = .Center
        
        refreshArrow = UIImageView(image: UIImage(named: "arrow.png"))
        refreshArrow.frame = CGRect(x: (view.bounds.height - 27) / 2, y: (view.bounds.height - 40) / 2, width: 27, height: 44)
        
        refreshSpinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
        refreshSpinner.frame = CGRect(x: (view.bounds.height - 20) / 2, y: (view.bounds.height - 20) / 2, width: 20, height: 20)
        refreshSpinner.hidesWhenStopped = true
        
        
        view.addSubview(refreshLabel)
        view.addSubview(refreshArrow)
        view.addSubview(refreshSpinner)
        
        addSubview(view)
    }
    
    private func willStartRefresh() {
        if let d = delegate  {
            if  d.respondsToSelector(Selector("refreshViewWillStartRefresh:")) {
                d.refreshViewWillStartRefresh!(self)
            }
        }
    }
    
   
    private func didStartRefresh() {
        if let d = delegate {
            if d.respondsToSelector(Selector("refreshViewDidStartRefresh:")) {
                d.refreshViewDidStartRefresh!(self)
            }
        }
    }
    //默认状态
    func defaultState() {
        state = .Normal
        refreshLabel.text = tips[state.rawValue]
        refreshArrow.hidden = false
    }
    //即将刷新
    func willRefresh() {
        state = .WillRefresh
        refreshLabel.text = tips[state.rawValue]
        refreshArrow.hidden = false
    }
    //开始刷新
    func startRefresh() {
        willStartRefresh()
        starting()
        didStartRefresh()
        
    }
    //刷新完成
    func endRefresh() {
        ending()
        didEndRefresh()
        defaultState()
    }
    
    private func starting() {
        refreshing = true
        state = .Refreshing
        refreshLabel.text = tips[state.rawValue]
        refreshArrow.hidden = true
        refreshSpinner.startAnimating()
    }
    private func ending() {
        refreshing = false
        state = .Refreshed
        refreshLabel.text = tips[state.rawValue]
        refreshSpinner.stopAnimating()
    }
    private func didEndRefresh() {
        if let d = delegate {
            if d.respondsToSelector("refreshViewDidEndRefresh:") {
                d.refreshViewDidEndRefresh!(self)
            }
        }
    }
    
   
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

@objc
public protocol LTRefreshViewDelegate: NSObjectProtocol {
    optional func refreshViewWillStartRefresh(view: LTRefreshView)
    optional func refreshViewDidStartRefresh(view: LTRefreshView)
    optional func refreshViewDidEndRefresh(view: LTRefreshView)
}

