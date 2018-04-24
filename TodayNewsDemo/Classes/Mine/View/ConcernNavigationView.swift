//
//  ConcernNavigationView.swift
//  TodayNewsDemo
//
//  导航条

import UIKit

protocol ConcernNavigationViewDelegate: class {
    
    func concernHeaderViewReturnButtonClicked()
    
    func concernHeaderViewMoreButtonClicked()
}

class ConcernNavigationView: UIView, LoadNibProtocol {
    
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var bottomLine: UIView!
    
    weak var delegate: ConcernNavigationViewDelegate?
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 关注按钮
    @IBOutlet weak var concernButton: UIButton!
    /// 返回按钮
    @IBOutlet weak var returnButton: UIButton!
    /// 更多按钮
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        concernButton.layer.borderColor = UIColor.lightGray.cgColor
        concernButton.layer.borderWidth = 1
        width = screenWidth
        height = 64
    }
    
    @IBAction func returnButtonClicked(_ sender: UIButton) {
        delegate?.concernHeaderViewReturnButtonClicked()
    }
    
    @IBAction func moreButtonClicked(_ sender: UIButton) {
        delegate?.concernHeaderViewMoreButtonClicked()
    }
    
}
