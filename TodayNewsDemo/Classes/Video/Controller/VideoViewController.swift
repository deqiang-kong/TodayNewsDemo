//
//  VideoViewController.swift
//  TodayNewsDemo
//
//
//  视频 控制器

import UIKit

protocol VideoViewControllerDelegate : class {
    func videoViewController(_ videoViewController : VideoViewController, targetIndex : Int)
}

class VideoViewController: UIViewController {
    
    weak var delegate: VideoViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
//    fileprivate var startOffsetX: CGFloat = 0
//    fileprivate var isForbidScroll: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        VideoAPI.loadVideoTitlesData { (videoTitles, videoTopicVCs) in
            // 将所有子控制器添加到父控制器中
            for childVc in videoTopicVCs {
                self.addChildViewController(childVc)
            }
            
            self.pageView.titles = videoTitles
            self.pageView.childVcs = self.childViewControllers as? [VideoTopicController]
            self.setupUI()
        }
    }

    
    // 导航栏样式修改
    func setNavigationBar() {
        // 设置导航栏颜色
        navigationController?.navigationBar.theme_barTintColor = "colors.homeNavBarTintColor"
        // 设置状态栏属性
        //navigationController?.navigationBar.barStyle = .black
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
    
    
    // 自定义导航栏
    fileprivate lazy var homeNavigationBar: UIView = {
        let navigationBar = UIView()
        navigationBar.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:40)
        
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
    
    
    fileprivate lazy var pageView: VideoPageView = {
        let pageView = VideoPageView()
        return pageView
    }()
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - setupUI
extension VideoViewController {
    // 设置 UI
    fileprivate func setupUI() {
        
       
        view.addSubview(pageView)
        
        pageView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(view).offset(kNavBarHeight)
        }
        
        
//        //videoTitleSelectedClicked
//        NotificationCenter.default.addObserver(self, selector: #selector(videoTitleSelectedClicked(notification:)), name: NSNotification.Name(rawValue: "videoTitleSelectedClicked"), object: nil)
    }
    
//    /// 视频内容指定类型刷新
//    @objc func videoTitleSelectedClicked(notification: Notification) {
//        
//    }
}

extension VideoViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoTopicViewCell", for: indexPath)
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        let childVc = childViewControllers[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
    
}


