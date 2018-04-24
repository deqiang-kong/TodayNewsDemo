//
//  TheyUseCollectionCell.swift
//  TodayNewsDemo
//
//  他们也在用 Cell

import UIKit
import Kingfisher

class TheyUseCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var vipImageView: UIImageView!
    /// 头像
    @IBOutlet weak var avatarImageView: UIImageView!
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    /// 子标题
    @IBOutlet weak var subtitleLabel: UILabel!
    /// 关注
    @IBOutlet weak var concernButton: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    
    var userCard: UserCard? {
        didSet {
            
            let icon = userCard!.user!.info!.avatar_url!
            avatarImageView.kf.setImage(with: URL(string: icon))
            
            nameLabel.text = userCard!.user!.info!.name!
            subtitleLabel.text = userCard!.recommend_reason!
            subtitleLabel.numberOfLines = 2
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.cellBackgroundColor"
        closeButton.theme_setImage("images.iconPopupClose", forState: .normal)
    }

}
