//
//  ChannelCategoryController.swift
//  TodayNewsDemo
//
//  频道管理

import UIKit
import IBAnimatable
import SVProgressHUD

class ChannelCategoryController: AnimatableModalViewController, StoryboardLoadable {
    
    /// 是否编辑
    var isEdit = false
    
    // 本地存储数据
    // 我的定制频道
    var myCustomChannels = [ChannelModel]()
    // 剩余频道数据
    var surplusChannels = [ChannelModel]()
    
    // 网络请求数据
    // 频道推荐数据
    var recommendChannels = [ChannelModel]()
    // 频道备选数据
    var optionalChannels = [ChannelModel]()
    
    // 屏道数据回传
    var channelsBackDelegate: ChannelsBackDelegate?
    // 数据回传标识
    var channelsBackStaus = false
    // 频道选择
    var channelIndex = -1
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        // 每个 cell 的大小
        layout.itemSize = CGSize(width: (screenWidth - 50) * 0.25, height: 44)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
        
        // 注册 cell 和头部
        collectionView.ym_registerCell(cell: AddCategoryCell.self)
        collectionView.ym_registerCell(cell: ChannelRecommendCell.self)
        collectionView.ym_registerSupplementaryHeaderView(reusableView: ChannelRecommendReusableView.self)
        collectionView.ym_registerSupplementaryHeaderView(reusableView: MyChannelReusableView.self)
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addGestureRecognizer(longPressRecognizer)
        
        // 订阅编辑监听
        NotificationCenter.default.addObserver(self, selector: #selector(editChannelTarget), name: NSNotification.Name(rawValue: "editChannelTarget"), object: nil)
        //装载频道数据
        loadChannelData()
    }
    
    // 获取频道数据，推荐数据，备选数据
    func loadChannelData(){
        SVProgressHUD.show(withStatus: "正在加载...")
        SVProgressHUD.setBackgroundColor(UIColor(r: 0, g: 0, b: 0, alpha: 0.5))
        SVProgressHUD.setForegroundColor(UIColor.white)
        
        // 获取我的频道列表
        ChannelAPI.getMyChannels{ [unowned self] (channels) in
            
            self.myCustomChannels = channels!
        }
        
        // 获取推荐频道列表
        ChannelAPI.getRecommendChannels{ [unowned self] (channels) in
            
            self.recommendChannels = channels!
        }
        // 获取备选频道列表
        ChannelAPI.getOptionalChannels{ [unowned self] (channels) in
            
            SVProgressHUD.dismiss()
            self.optionalChannels = channels!
           
            
            self.surplusChannels = self.optionalChannels
            self.getSurplusChannels()
            self.collectionView.reloadData()
        }
    }
    
    
    func getSurplusChannels(){
        // 推荐频道中的未选中的频道
        var unselectedChannelsd  = [ChannelModel]()
        for channel in recommendChannels{
            var status = false
            for myChannel in myCustomChannels{
                if (channel.category?.elementsEqual(myChannel.category!))!{
                    status = true
                    break
                }
            }
            
            // 频道被选中
            if status{
                
            }
            else{
                // 未选中的频道
                unselectedChannelsd.append(channel)
            }
        }
        //surplusChannels = optionalChannels
        for channel in unselectedChannelsd{
            
            surplusChannels.append(channel)
        }
       
    }
    
    // 编辑按钮状态变更
    @objc fileprivate func editChannelTarget() {
        isEdit = !isEdit
        self.collectionView.reloadData()
    }
    
    lazy var longPressRecognizer: UILongPressGestureRecognizer = {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressTarget))
        return longPress
    }()
    
    @objc fileprivate func longPressTarget(longPress: UILongPressGestureRecognizer) {
        let selectedIndexPath = collectionView.indexPathForItem(at: longPress.location(in: collectionView))
        if selectedIndexPath?.section != 0{
            return
        }
        // 通知触发长按事件
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "longPressTarget"), object: nil)
        
        switch longPress.state {
        case .began:
            if isEdit { // 选中的是上部的 cell,并且是可编辑状态
                collectionView.beginInteractiveMovementForItem(at: selectedIndexPath!)
            } else { //
                isEdit = true
                collectionView.reloadData()
                if (selectedIndexPath != nil) && (selectedIndexPath?.section == 0) {
                    collectionView.beginInteractiveMovementForItem(at: selectedIndexPath!)
                }
            }
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(longPress.location(in: longPressRecognizer.view))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    /// 关闭按钮
    @IBAction func closeAddCategoryButtonClicked(_ sender: UIButton) {
        closeCategory()
    }
    
    /// 数据保存
    func closeCategory(){
        
        dismiss(animated: true, completion: nil)
    }
    
    // 当视图将要消失时调用该方法
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 数据回传
        if channelsBackStaus{
            if let data = channelsBackDelegate {
                data.channelsBack(channels: myCustomChannels,index: channelIndex)
            }
        }
        
        ChannelAPI.saveMyChannelCacheData(data: myCustomChannels)
    }
    
    // 当时图已经消失时调用该方法
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: -我的频道 action
extension ChannelCategoryController: MyChannelReusableViewDelegate, AddCategoryCellDelagate {
    
    /// 屏道按钮点击
    func channelClicked(of cell: AddCategoryCell) {
        let indexPath = collectionView.indexPath(for: cell)
        if isEdit {
            
            let entity = myCustomChannels[indexPath!.item]
            if(entity.type != 0){
                // 上部删除，下部添加
                surplusChannels.insert(myCustomChannels[indexPath!.item], at: 0)
                collectionView.insertItems(at: [IndexPath(item: 0, section: 1)])
                myCustomChannels.remove(at: indexPath!.item)
                collectionView.deleteItems(at: [IndexPath(item: indexPath!.item, section: 0)])
                channelsBackStaus = true
            }
        }else{
            channelIndex = indexPath!.item
            closeCategory()
        }
    }
    
    /// 删除按钮点击
    func deleteCategoryButtonClicked(of cell: AddCategoryCell) {
        // 上部删除，下部添加
        let indexPath = collectionView.indexPath(for: cell)
        surplusChannels.insert(myCustomChannels[indexPath!.item], at: 0)
        collectionView.insertItems(at: [IndexPath(item: 0, section: 1)])
        myCustomChannels.remove(at: indexPath!.item)
        collectionView.deleteItems(at: [IndexPath(item: indexPath!.item, section: 0)])
    }
    
    /// 编辑按钮点击
    func channelReusableViewEditButtonClicked(_ sender: UIButton) {
        isEdit = sender.isSelected
        collectionView.reloadData()
    }
    
}


extension ChannelCategoryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// 头部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let myChannelReuseableView = collectionView.ym_dequeueReusableSupplementaryHeaderView(indexPath: indexPath) as MyChannelReusableView
            return myChannelReuseableView
        } else if indexPath.section == 1 {
            let channelreuseableView = collectionView.ym_dequeueReusableSupplementaryHeaderView(indexPath: indexPath) as ChannelRecommendReusableView
            return channelreuseableView
        }
        return UICollectionReusableView()
    }
    
    
    /// headerView 的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 60)
    }
    
    /// cell 的组数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    /// 每组 cell 的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return myCustomChannels.count
        } else if section == 1 {
            return surplusChannels.count
        }
        return 0
    }
    /// cell 布局展示
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 我选择的频道列表
        if indexPath.section == 0 {
            let cell = collectionView.ym_dequeueReusableCell(indexPath: indexPath) as AddCategoryCell
            let category = myCustomChannels[indexPath.item]
            let type = category.type
            
            cell.delegate = self
            cell.titleButton.setTitle(category.name!, for: .normal)
            cell.setTypeColor(type : type)
            cell.isEdit = isEdit
            
            return cell
        }
            // 备选频道列表
        else {
            let cell = collectionView.ym_dequeueReusableCell(indexPath: indexPath) as ChannelRecommendCell
            let category = surplusChannels[indexPath.item]
            cell.titleButton.setTitle(category.name!, for: .normal)
            return cell
        }
    }
    
    /// 点击了某一个 cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } // 备选频道添加到我的频道
        else {
            // 添加
            myCustomChannels.append(surplusChannels[indexPath.item])
            collectionView.insertItems(at: [IndexPath(item: myCustomChannels.count - 1, section: 0)])
            // 删除
            surplusChannels.remove(at: indexPath.item)
            collectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 1)])
        }
        
    }
    
    /// 我的屏道移动 cell
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if !isEdit || sourceIndexPath.section == 1 {
            return
        }
        
        /// 移动对象到指定位置 cell
        let entity=myCustomChannels.remove(at: sourceIndexPath.item)
        myCustomChannels.insert(entity, at: destinationIndexPath.item)
        //let tempArray: NSMutableArray = homeTitles as! NSMutableArray
        //tempArray.exchangeObject(at: sourceIndexPath.item, withObjectAt: destinationIndexPath.item)
        collectionView.reloadData()
    }
    
    /// 每个 cell 之间的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    // 下滑返回
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        if scrollView.contentOffset.y < -100{
            dismiss(animated: true, completion: nil)
        }
    }
}
