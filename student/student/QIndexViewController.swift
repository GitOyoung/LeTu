//
//  QIndexViewController.swift
//  student
//
//  Created by oyoung on 16/1/22.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit

enum IndexStyle {
    case Done
    case New
}

protocol QIndexViewControllerExitDelegate {
    func exit(viewController: QIndexViewController)
}

class QIndexViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var contentTop: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!

    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    var collection: [IndexStyle] = []
    
    var currentIndex: Int = -1
    
    var selectedIndex: Int = -1
    
    var delegate: QIndexViewControllerExitDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerNib(UINib(nibName: "QIndexCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupCollectionView() {
        var h = collectionView.contentSize.height
        collectionHeight.constant = h
        h += 40
        contentHeight.constant = h
        contentTop.constant = -h
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupCollectionView()
        UIView.animateWithDuration(1) {
            self.contentTop.constant = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        if let d = delegate {
            d.exit(self)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var ccell = collectionView.dequeueReusableCellWithReuseIdentifier("CCell", forIndexPath: indexPath) as? QIndexCollectionViewCell
        let style = collection[indexPath.row]
        if ccell == nil {
            ccell = QIndexCollectionViewCell()
        }
        if let cell = ccell {
            switch style {
            case .Done:
                cell.textColor = UIColor.whiteColor()
                cell.bgColor = UIColor(red: 0.454, green: 0.494, blue: 0.533, alpha: 1)
            case .New:
                cell.textColor = UIColor(red: 0, green: 0.588, blue: 0.980, alpha: 1) //0, 150, 250
                cell.bgColor = UIColor.whiteColor()
                cell.borderWidth = 2
                cell.borderColor = UIColor(red: 0, green: 0.588, blue: 0.980, alpha: 1).CGColor //0, 150, 250
            }
            
            if currentIndex == indexPath.row {
                cell.textColor = UIColor.whiteColor()
                cell.borderWidth = 0
                cell.bgColor = UIColor(red: 0, green: 0.588, blue: 0.980, alpha: 1) //0, 150, 250
            }
            cell.cornerRadius = 21
            cell.text = String(indexPath.row + 1)
        }
        return ccell!
    }
    
    @IBAction func exit(sender: AnyObject) {
        if let d = delegate {
            d.exit(self)
        }
    }
    

}
