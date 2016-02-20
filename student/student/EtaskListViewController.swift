//
//  EtaskListViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//
import UIKit



class EtaskListViewController: UIViewController, HttpProtocol, ArrowMenuDelegate,UITableViewDelegate, UITableViewDataSource, LTRefreshViewDelegate {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var mainSegment: UISegmentedControl!
 
    @IBOutlet weak var tipsButton: UIButton!
    
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
 
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopOffset: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var refreshTip: UILabel!
    
    
    let http: HttpRequest = HttpRequest()
    
    //    
 
    var dataSource = NSMutableArray()
    var subjectName:String = ""
    var newTaskCount: Int = 0 {
        didSet {
            if newTaskCount > 0 {
                let count = newTaskCount
                let tips = "有\(count)份新作业未完成"
                tipsButton.setTitle(tips, forState: UIControlState.Normal)
                showTipsButton(true)
            }
            else {
                showTipsButton(false)
            }
        }
    }
    
    var page: Int = 0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.titleView.backgroundColor = QKColor.themeBackgroundColor_1()
        http.delegate = self
        setMainSegment()
        setSearchBar()
        setupTableView()
        setupScrollView()
        setupButton()
        setupFooter()
        addNotifObserver()
        
    }
    
    func addNotifObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("menuHide:"), name: "SortMenuShouldHide", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        page = 0
        requestData(page)
    }
    
    func setupButton()
    {
        sortButton.addTarget(self, action: Selector("sortButtonClick:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
 
    private var menu: ArrowMenu?
    @objc(sortButtonClick:)
    func sortButtonTouchedUpInside(sender s: UIButton)
    {
        if menu == nil
        {
            var origin = s.convertPoint(s.frame.origin, toView: view)
            origin.y += s.frame.height - 6
            origin.x -= 6
            menu = ArrowMenu(frame: CGRect(origin: origin, size: CGSize(width: 114, height: 154)), delegate: self)
            menu!.cornerRadius = 6
            menu!.arrowDirection = ArrowDirection.Up
            menu!.arrowOffset = 0
            menu!.backColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            menu!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
            menu!.contentView?.backgroundColor = UIColor.clearColor()
            menu!.contentView?.layer.cornerRadius = 6
            menu?.hidden = true
            view.addSubview(menu!)
        }
        let hidden = (menu?.hidden)!
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.menu?.hidden = !hidden
        }
        
        
    }
    
    func menuHide(notif: NSNotification) {
        setMenuHidden(true)
    }
    
    func setMenuHidden(hidden: Bool) {
        if let m = menu {
            m.hidden = hidden
        }
    }
    
    func setupScrollView() -> Void {
        scrollView.delegate = self
        scrollView.tag = 1
    }
    
    
    func SortWithIndex(index n: Int)
    {
        //排序的具体实现
    }
 
    
    func setupTableView() -> Void {
        
 
        tableView.registerClass(EtaskTableViewCell.self, forCellReuseIdentifier: "etaskTableViewCell")
        tableView.registerNib(UINib(nibName: "EtaskTableViewCell", bundle: nil), forCellReuseIdentifier: "etaskTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = 0
        tableView.estimatedRowHeight = 44
        tableView.clipsToBounds = true
        tableView.contentOffset = CGPoint(x: 0, y: 0)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.checkUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showTipsButton(showed: Bool) {
        if showed {
            tipsButton.hidden = false
            tableViewTopOffset.constant = 12 + tipsButton.bounds.size.height
        }
        else {
            tipsButton.hidden = true
            tableViewTopOffset.constant = 6
        }
    }
    
    func segmentIndexChangedTips(sender: UISegmentedControl)
    {
        let selectSegText = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex);
        let message = String(format: "你选中了%@", selectSegText!);
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert);
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil);
        
        alert.addAction(cancelAction);
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    @IBAction func mainSegmentIndexChanged(sender: UISegmentedControl)
    {
        //segmentIndexChangedTips(sender);
        page = 0
        requestData(page)
    }
    
    private func setSearchBar()
    {
        sortButton.layer.cornerRadius = 5
        searchBar.backgroundColor = UIColor.whiteColor()
        searchBar.searchBarStyle = .Default
        searchBar.layer.masksToBounds = true
        searchBar.layer.borderWidth = 0.0
    }
    
 
    
    
    
    private func setMainSegment() {
        // 设置segment
        // 去掉segment颜色,现在整个segment都看不见
        mainSegment.tintColor = QKColor.clearColor()
        // 设置选中／非选中时，文字属性
        mainSegment.setTitleTextAttributes([NSForegroundColorAttributeName: QKColor.themeBackgroundColor_1(), NSFontAttributeName: UIFont.boldSystemFontOfSize(16)], forState: UIControlState.Selected)
        mainSegment.setTitleTextAttributes([NSForegroundColorAttributeName:QKColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(16)], forState: UIControlState.Normal)
        // 设置选中／非选中时，背景图片
        var selectedImage = UIImage(named: "ask_white_btn");
        selectedImage = selectedImage!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.Stretch);
        var unselectedImage = UIImage(named: "ask_blue_btn");
        unselectedImage = unselectedImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.Stretch);
        mainSegment.setBackgroundImage(unselectedImage, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default);
        mainSegment.setBackgroundImage(selectedImage, forState: UIControlState.Selected, barMetrics: UIBarMetrics.Default);
        mainSegment.setBackgroundImage(selectedImage, forState: UIControlState.Highlighted, barMetrics: UIBarMetrics.Default);
        
        mainSegment.addTarget(self, action: Selector("mainSegmentIndexChanged:"), forControlEvents: UIControlEvents.ValueChanged);
    }

    
    
    private func checkUser()
    {
        if NSUserDefaultUtil.getUser() == nil
        {
            let meLoginViewController = MeLoginViewController()
            self.presentViewController(meLoginViewController, animated: true, completion: nil)
        }
        
    }
    
    func didreceiveResult(result: NSDictionary) {
        let isSuccess:Bool = result["isSuccess"] as! Bool
        if isSuccess {
            var count = 0
            let data:[NSDictionary] = result["data"] as! [NSDictionary]
            if page == 0 {
                dataSource.removeAllObjects()
            }
            for etask in data{
                let currentEtask = EtaskModel(info: etask)
                dataSource.addObject(currentEtask)
                if currentEtask.isNewTask(){
                    count += 1
                }
            }
            ++page
            newTaskCount = count
            endRefresh(refreshStyle: refreshStyle)
            if case .PullUp = refreshStyle {
                return
            }
            tableViewReloadData()
        }else{
            if NSUserDefaultUtil.getUser() == nil {
                self.presentViewController(MeLoginViewController(), animated: true, completion: nil)
            }
        }

    }
    
    @IBAction func jumpToNewEtaskView(sender: AnyObject) {
        showTipsButton(false)
        let newEtaskVC = NewEtaskListViewController()
        self.presentViewController(newEtaskVC, animated: true, completion: nil)
    }
    
    //tableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count > 0 ? dataSource.count : 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("etaskTableViewCell", forIndexPath: indexPath) as! EtaskTableViewCell
        let etaskModel: EtaskModel = dataSource[indexPath.section] as! EtaskModel
        
        cell.initCell(etaskModel)
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 6
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 6
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view: UIView = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.clearColor()
        return view
    }
 
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let etaskModel: EtaskModel = dataSource[indexPath.section] as! EtaskModel
        let etaskWorkonViewController = EtaskWorkonViewController()
        etaskWorkonViewController.etask = etaskModel
        print("etask list jump to etaskWorkOn")
        
        //        let etaskDetailVC = EtaskDetailViewController()
        //        etaskDetailVC.etask = etaskModel
        
        self.presentViewController(etaskWorkonViewController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == dataSource.count - 1 {
            updateFooterView()
        }
    }
    
    func updateFooterView() {
        footerView?.frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.width, height: (footerView?.frame.height)!)
    }
    
    private var isDrag: Bool = false
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isDrag = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if scrollView.tag == 0 //tableView
        {
            var offset = scrollView.contentOffset
            offset.y = max(offset.y, 0)
            scrollView.contentOffset = offset
            if let view = footerView {
                if view.refreshing && offset.y > 0 {
                    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height, right: 0)
                } else if isDrag && scrollView.contentSize.height - (offset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= 0 {
                    if scrollView.contentSize.height - (offset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= -view.bounds.height {
                        view.willRefresh()
                    } else {
                        view.defaultState()
                    }
                }
            }
            
        }
        else if  scrollView.tag == 1 //scrollView
        {
            var offset = scrollView.contentOffset
            offset.y = max(offset.y, -80)
            offset.y = min(offset.y, scrollView.frame.height - scrollView.contentSize.height)
            scrollView.contentOffset = offset
            if isDrag
            {
                if offset.y > -75
                {
                    refreshTip.text = "下拉更新"
                }
                else 
                {
                    refreshTip.text = "松开刷新"
                }
            }
        }
    }
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        isDrag = false
        if scrollView.tag == 0 {
            let offset = scrollView.contentOffset
            if !refreshing && scrollView.contentSize.height - (offset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= -(footerView?.bounds.height)! && offset.y > 0  {
                startRefresh(refreshStyle: .PullUp)
            }
        } else if scrollView.tag == 1 {
            if scrollView.contentOffset.y < -79
            {
                startRefresh()
            }
        }
    }
    
    var footerView: LTRefreshView?
    private var refreshStyle: LTRefreshStyle = LTRefreshStyle.PullDown
    private var refreshing: Bool = false
    func startRefresh(refreshStyle style: LTRefreshStyle = LTRefreshStyle.PullDown) {
        refreshing = true
        refreshStyle = style
        switch style
        {
        case .PullDown:
            page = 0
            if !indicator.isAnimating()
            {
                indicator.startAnimating()
            }
            refreshTip.text = "正在更新"
            scrollView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0)
            requestData(page)
        case .PullUp:
            footerView?.startRefresh()
        }
    }
    
    func endRefresh(refreshStyle style: LTRefreshStyle = LTRefreshStyle.PullDown) {
        if refreshing {
            refreshing = false
            switch style
            {
            case .PullDown:
                indicator.stopAnimating()
                self.refreshTip.text = "更新成功"
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                    }, completion: { (done: Bool) -> Void in
                        
                })
            case .PullUp:
                footerView?.endRefresh()
            }
        }
        
    }
    
    func setupFooter() {
        var frame = tableView.bounds
        frame.size.height = 52
        frame.origin.y = tableView.frame.size.height + 20
        footerView = LTRefreshView(frame: frame)
        footerView?.delegate = self
        footerView?.contentScale = RefreshContentScale(sx: 1.0, sy: 1.0)
        footerView?.backColor = UIColor.clearColor()
        tableView.addSubview(footerView!)
    }
    
    func refreshViewWillStartRefresh(view: LTRefreshView) {
        requestMoreData()
    }
    
    func refreshViewDidStartRefresh(view: LTRefreshView) {
//        var inset = tableView.contentInset
//        inset.bottom = tableView.contentSize.height - tableView.frame.height + 40
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (footerView?.bounds.height)!, right: 0)
        tableView.scrollEnabled = false
    }
    
    func refreshViewDidEndRefresh(view: LTRefreshView) {
        tableView.scrollEnabled = true
        tableViewReloadData()
    }
    
    func tableViewReloadData() {
        tableView.reloadData()
        updateFooterView()
    }
    
    func requestMoreData() {
        requestData(page)
    }
    
    // MARK: 刷新数据
    func requestData(pageIndex: Int) {
        let url = ServiceApi.getSearchEtaskListUrl()
        let user:UserModel? = NSUserDefaultUtil.getUser()
        if user != nil
        {
            /*
            userId	Long	是		用户ID
            orderDate	Integer	是	1	是否按作业开始日期排序类型 (1:是 0:否)
            status	Integer	是	0	状态,按照作业状态进行筛选
            0:全部 1:未开始 2:未完成 3:未批改 4:未订正 5:已完成
            subject	Integer	是	0	科目,按照科目进行筛选
            0:全部 1:语文 2:数学 3:英语 (暂时只是小学阶段语数外)
            timeSlice	Integer	是	0	按照时间段来筛选
            0:全部 1:当天 2:本周 3:当月 4:本学期
            etaskType	Integer	是	0	作业类型 0:全部 1:随堂练习 2:假期作业
            pageIndex	Integer	是	0	获取数据的页面索引,默认为0
            pageSize	Integer	是	10	每次获取数据的数量,默认为10
            accessToken
            */
            var params = [String:AnyObject]()
            params["userId"] = user!.userId!
            params["orderDate"] = 1
            params["status"] = 0
            params["subject"] = mainSegment.selectedSegmentIndex
            params["timeSlice"] = 0
            params["etaskType"] = 0
            params["pageIndex"] = pageIndex
            params["pageSize"] = 10
            params["accessToken"] = user!.token!
            http.postRequest(url, params: params)
        }else{
            self.presentViewController(MeLoginViewController(), animated: true, completion: nil)
        }
    }
    
    var touchedItem: MenuItem?
    
    func arrowMenu(menu: ArrowMenu, canBeSelectedAtRow row: Int, colunm: Int) -> Bool {
        return true
    }
    
    func arrowMenu(menu: ArrowMenu, didSelectAtRow row: Int, colunm: Int) {
        menu.hidden = true
        let item = menu[row, colunm]!
        if touchedItem != nil
        {
            touchedItem?.backgroundColor = UIColor.clearColor()
            touchedItem?.textColor = UIColor.whiteColor()
        }
        
        item.backgroundColor = UIColor(white: 0.467, alpha: 1.0)
        item.textColor = UIColor(red: 1.0, green: 155.0/255, blue: 0, alpha: 1.0)
        
        touchedItem = item
        SortWithIndex(index: row)
//        let view = FollowReadingViewController()
//        self.presentViewController(view, animated: true, completion: nil)
    }
    
    //气泡菜单的委托方法
    
    func numberOfColunm(menu: ArrowMenu) -> Int {
        return 1
    }
    
    func arrowMenu(menu: ArrowMenu, numnerOfRowInColunm: Int) -> Int {
        return 4
    }
    
    
    func arrowMenu(menu: ArrowMenu, widthForColunm colunm: Int) -> CGFloat {
        return 114
    }
    
    func arrowMenu(menu: ArrowMenu, heightForRow row: Int, colunm: Int) -> CGFloat {
        return 37
    }
    
    func arrowMenu(menu: ArrowMenu, insetForRow: Int, colunm: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }
    
    func arrowMenu(menu: ArrowMenu, itemForRow row: Int, colunm: Int) -> MenuItem {
        var item = menu[row, colunm]
        if item == nil
        {
            item = MenuItem()
            item?.backgroundColor = UIColor.clearColor()
            item?.textAlignment = .Center
            item?.textColor = UIColor.whiteColor()
            item?.font = UIFont.systemFontOfSize(12)
            item?.text = "按时间排序"
        }
        
        return item!
    }

}