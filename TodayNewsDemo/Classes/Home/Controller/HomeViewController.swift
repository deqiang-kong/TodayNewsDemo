//
//  HomeViewController.swift
//  TodayNewsDemo
//
//  self （navigationBar，HomePageView）=> HomePageView（HomeTitleView，[TopicViewController]）=>
//
//
//  首页 控制器

import UIKit
import SnapKit

class HomeViewController: UIViewController ,ChannelsBackDelegate{
    
    
   //var homeTopicVCs = [TopicViewController]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.globalBackgroundColor()
        
        setNavigationBar()
        // 获取备选频道列表
        ChannelAPI.getMyChannels{ [unowned self] (channels) in
            
            self.getMyChannelsData(channels :channels )
        }
    }
    
    // 导航栏样式修改
    func setNavigationBar() {
        // 设置导航栏颜色
        navigationController?.navigationBar.theme_barTintColor = "colors.homeNavBarTintColor"
        // 设置状态栏属性
        navigationController?.navigationBar.barStyle = .black
        // 修改导航栏文字颜色
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        // 修改导航栏按钮颜色
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        // 修改导航背景图片*  *不包含状态栏：*44*点（*88*像素）*  *包含状态栏：*64*点*(128*像素）
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "title_night_72x20_"), for: .default)
        // 设置导航栏
        navigationItem.title = ""
        navigationItem.titleView = homeNavigationBar
        //        let rightBtn = UIBarButtonItem(customView: homeNavigationBar)
        //        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    
    func channelsBack(channels: [ChannelModel]? , index : Int){
        //let channel = channels![index]
        // 获取屏道列表
        getMyChannelsData(channels :channels )
        
        if index >= 0 {
            // 调整当前屏道
            pageView.setCurrentIndex(index: index)
            self.setupUI()
        }
    }
    
    
    // 获取我的频道列表
    func getMyChannelsData(channels: [ChannelModel]?){
        var homeTopicVCs = [TopicViewController]()
        // 创建 对等实例
        for channel in channels! {
            // 添加控制器
            let firstVC = TopicViewController()
            firstVC.topicTitle = channel
            homeTopicVCs.append(firstVC)
        }
        
        // 将所有子控制器添加到父控制器中
        for childVc in homeTopicVCs {
            self.addChildViewController(childVc)
        }
        
        self.pageView.titles = channels
        self.pageView.childVcs = self.childViewControllers as? [TopicViewController]
        self.setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate lazy var pageView: HomePageView = {
        let pageView = HomePageView()
        return pageView
    }()
    
    
    // 自定义导航栏
    fileprivate lazy var homeNavigationBar: UIView = {
        let navigationBar = UIView()
        navigationBar.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:40)
        // UIView添加点击事件
        //navigationBar.isUserInteractionEnabled = true
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchClicked))
        //tapGesture.numberOfTapsRequired = 1
        //navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //navigationBar.addGestureRecognizer(tapGesture)
        
        // 添加今日头条 图片
        navigationBar.addSubview(toutiaoImageView)
        toutiaoImageView.frame = CGRect(x:10, y:8, width:86, height:24)
        
        let searchBtn:UIButton = UIButton(frame: CGRect(x: 110, y: 5, width: 220, height: 30))
        searchBtn.setBackgroundImage(UIImage(named:"searchbox_search_20x28_"), for: UIControlState.normal)
        
        searchBtn.setImage(UIImage(named: "searchicon_search_20x20_"), for: UIControlState.normal)
        searchBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) //文字大小
        searchBtn.setTitle("搜你想搜的", for: UIControlState.normal) //按钮文字
        searchBtn.setTitleColor(UIColor(r: 0, g: 0, b: 0, alpha: 0.5), for: UIControlState.normal)
        searchBtn.addTarget(self, action: #selector(searchClicked),for: .touchUpInside)
        // 内容左对齐
        searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        //按钮上图片的边距
        searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0,10, 0,0)
        //按钮内容的边距（顶部，左边，底部，左边）
        searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        //searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0,0)
        
        navigationBar.addSubview(searchBtn)
        
        return navigationBar
    }()
    
    
    // 今日头条 图片
    lazy var toutiaoImageView: UIImageView = {
        let toutiaoImageView = UIImageView(image: UIImage(named: UserDefaults.standard.bool(forKey: isNight) ? "title_night_72x20_" : "title_72x20_"))
        toutiaoImageView.contentMode = .scaleAspectFill
        return toutiaoImageView
    }()
    
    
    /// 搜索按钮点击
    @objc fileprivate func searchClicked() {
        let searchBarVC = HomeSearchViewController()
        navigationController?.pushViewController(searchBarVC, animated: true)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HomeViewController {
    
    fileprivate func setupUI() {
        
        view.addSubview(pageView)
        
        pageView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(view).offset(kNavBarHeight)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(homeTitleAddButtonClicked(notification:)), name: NSNotification.Name(rawValue: "homeTitleAddButtonClicked"), object: nil)
    }
    
    
    
    /// 进入频道管理
    @objc func homeTitleAddButtonClicked(notification: Notification) {
        let titles = notification.object as! [ChannelModel]
        let channelCategoryVC = ChannelCategoryController.loadStoryboard()
        channelCategoryVC.myCustomChannels = titles
        channelCategoryVC.modalSize = (width: .full, height: .custom(size: Float(screenHeight - 20)))
        channelCategoryVC.channelsBackDelegate = self
        present(channelCategoryVC, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

