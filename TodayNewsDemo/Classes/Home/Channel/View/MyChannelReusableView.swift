//
//  MyChannelRecommendView.swift
//  TodayNewsDemo
//
//  我的频道title

import UIKit

protocol MyChannelReusableViewDelegate: class {
    /// 编辑按钮点击
    func channelReusableViewEditButtonClicked(_ sender: UIButton)
}

/// 我的频道推荐
class MyChannelReusableView: UICollectionReusableView, RegisterCellOrNib {

    weak var delegate: MyChannelReusableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editChannelButton.layer.borderColor = UIColor.globalRedColor().cgColor
        editChannelButton.layer.borderWidth = 1
        editChannelButton.setTitle("完成", for: .selected)
        
        NotificationCenter.default.addObserver(self, selector: #selector(longPressTarget), name: NSNotification.Name(rawValue: "longPressTarget"), object: nil)
    }
    
    @objc private func longPressTarget() {
        editChannelButton.isSelected = true
        setLagelInfo(staus : editChannelButton.isSelected)
    }
    
    @IBOutlet weak var editChannelButton: UIButton!
    
    @IBOutlet weak var labelInfo: UIButton!
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.channelReusableViewEditButtonClicked(sender)
        
        setLagelInfo(staus : sender.isSelected)
        // 通知频道标签效果
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editChannelTarget"), object: nil)
    }
    
    func setLagelInfo(staus :Bool){
        if staus{
            labelInfo.setTitle("拖拽可以排序", for: .normal)
        }else{
             labelInfo.setTitle("点击进入频道", for: .normal)
        }
    }
    /// 移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
