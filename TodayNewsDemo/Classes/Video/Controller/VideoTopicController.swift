//
//  VideoTopicController.swift
//  TodayNewsDemo
//
//  视频 列表

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import BMPlayer
import MJRefresh
import SVProgressHUD
import NVActivityIndicatorView

class VideoTopicController: UIViewController {
    /// 播放器
    fileprivate lazy var player = BMPlayer()
    
    fileprivate let disposeBag = DisposeBag()
    /// 上一次点击的 cell
    var lastCell = VideoTopicCell()
    
    // 记录点击的顶部标题
    var videoTitle: TopicTitle?
    // 存放新闻主题的数组
    fileprivate var newsTopics = [WeiTouTiao]()
    // 下拉刷新标志
    var refreshFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let header = RefreshHeder(refreshingBlock: { [weak self] in
            var title = self!.videoTitle!.category!
            HomeAPI.getCategoryRefreshData(refresh: (self?.refreshFlag)! ,category: self!.videoTitle!.category!) { (nowTime, newsTopics) in
                
                self!.tableView.mj_header.endRefreshing()
                self!.newsTopics = newsTopics
                self!.tableView.reloadData()
                self?.refreshFlag = true
            }
        })
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            
            HomeAPI.getHomeCategoryMoreData(category: self!.videoTitle!.category!) { (nowTime, newsTopics) in
                
                if newsTopics.count == 0 {
                    SVProgressHUD.setForegroundColor(UIColor.white)
                    SVProgressHUD.setBackgroundColor(UIColor(r: 0, g: 0, b: 0, alpha: 0.3))
                    SVProgressHUD.showInfo(withStatus: "没有更多视频啦~")
                    self!.tableView.mj_footer.endRefreshing()
                    return
                }
                self!.newsTopics += newsTopics
                self!.tableView.reloadData()
            }
        })
    }
    
    fileprivate lazy var titleView: VideoTitleView = {
        let titleView = VideoTitleView()
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = screenHeight * 0.4
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentSize = CGSize(width: screenWidth, height: screenHeight - kNavBarHeight - kTabBarHeight)
        tableView.ym_registerCell(cell: VideoTopicCell.self)
        tableView.theme_backgroundColor = "colors.tableViewBackgroundColor"
        return tableView
    }()
}

extension VideoTopicController {
    
    fileprivate func setupUI() {
        
        view.addSubview(titleView)
        view.addSubview(tableView)
        
        titleView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(40)
            make.bottom.equalTo(view)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(view)
        }
    }
}

// MARK: - Table view data source
extension VideoTopicController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as VideoTopicCell
        cell.videoTopic = newsTopics[indexPath.row]
        // 头像区域点击
        cell.headCoverButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                let userVC = FollowDetailViewController()
                userVC.userid = cell.videoTopic!.media_info!.user_id!
                self!.navigationController!.pushViewController(userVC, animated: true)
            })
            .addDisposableTo(disposeBag)
        // 关注按钮点击
        cell.concernButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                
                
            })
            .addDisposableTo(disposeBag)
        // 评论按钮点击
        cell.commentButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                let videoDetailVC = VideoDetailController()
                videoDetailVC.videoCode = cell.videoTopic!.video_id!
                videoDetailVC.videoTopic = cell.videoTopic
                self!.navigationController!.pushViewController(videoDetailVC, animated: true)
            })
            .addDisposableTo(disposeBag)
        // 播放按钮点击
        cell.bgImageButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { (_) in
                if self.lastCell != cell {
                    if self.player.isPlaying {
                        self.player.removeFromSuperview()
                        self.lastCell.titleLabel.isHidden = false
                        self.lastCell.playCountLabel.isHidden = false
                        self.lastCell.timeLabel.isHidden = false
                    }
                }
                cell.titleLabel.isHidden = true
                cell.playCountLabel.isHidden = true
                cell.timeLabel.isHidden = true
                self.player = BMPlayer(customControlView: BMPlayerCustomControlView())
                
                cell.bgImageButton.addSubview(self.player)
                BMPlayerConf.allowLog = false
                BMPlayerConf.tintColor = UIColor.white
                BMPlayerConf.topBarShowInCase = .none
                BMPlayerConf.loaderType  = NVActivityIndicatorType.ballRotateChase
                
                self.player.snp.makeConstraints { (make) in
                    make.edges.equalTo(cell.bgImageButton)
                }
                /// 获取视频的真实链接
                HomeAPI.parseVideoRealURL(video_id: cell.videoTopic!.video_id!) { (realVideo) in
                    let asset = BMPlayerResource(url: URL(string: realVideo.video_1!.main_url!)!, name: cell.titleLabel.text!)
                    self.player.setVideo(resource: asset)
                    self.lastCell = cell
                }
            })
            .addDisposableTo(disposeBag)
        
        // 更多按钮点击 ，弹出对话框
        cell.moreButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                
                let alertController = UIAlertController(title: "提示", message: "我是提示框",preferredStyle: .actionSheet)
                let cancelAction1 = UIAlertAction(title: "确定", style: .default, handler: nil)
                let cancelAction2 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alertController.addAction(cancelAction1)
                alertController.addAction(cancelAction2)
                self?.present(alertController, animated: true, completion: nil)
                
            })
            .addDisposableTo(disposeBag)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoTopic = newsTopics[indexPath.row]
        /// 获取视频的真实链接
        HomeAPI.parseVideoRealURL(video_id: videoTopic.video_id!) { (realVideo) in
            let videoDetailVC = VideoDetailController()
            videoDetailVC.videoTopic = videoTopic
            videoDetailVC.realVideo = realVideo
            self.navigationController?.pushViewController(videoDetailVC, animated: true)
            if self.player.isPlaying { // 说明有正在播放的视频
                self.player.removeFromSuperview()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if player.isPlaying { // 说明有正在播放的视频
            let imageButton = player.superview
            let contentView = imageButton?.superview
            let cell = contentView?.superview as! VideoTopicCell
            let rect = tableView.convert(cell.frame, to: view)
            if (rect.origin.y <= -cell.height) || (rect.origin.y >= screenHeight - kTabBarHeight) {
                player.pause()
                player.removeFromSuperview()
            }
        }
    }
}

// MARK:- 遵守HYTitleViewDelegate
extension VideoTopicController : VideoTitleViewDelegate {
    
    func titleView(_ titleView: VideoTitleView, targetIndex : Int) {
        let indexPath = IndexPath(item: targetIndex, section: 0)
        //collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    /// 顶部搜索按钮点击
    func videoTitle(videoTitle: VideoTitleView, didClickSearchButton searchButton: UIButton) {
        
    }
}
