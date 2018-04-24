//
//  ChannelRecommendCell.swift
//  TodayNewsDemo
//
//  备选频道标签按钮

import UIKit



class ChannelRecommendCell: UICollectionViewCell, RegisterCellOrNib {
    
    @IBOutlet weak var titleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.theme_backgroundColor = "colors.cellBackgroundColor"
        titleButton.theme_backgroundColor = "colors.cellBackgroundColor"
        titleButton.theme_setImage("images.addChannelTitlbar", forState: .normal)
        layer.cornerRadius = 3
        
        titleButton.layer.shadowColor = UIColor(r: 240, g: 240, b: 240).cgColor
        titleButton.layer.shadowOffset = CGSize(width: 0, height: 0)        //shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        titleButton.layer.shadowOpacity = 1                                 //阴影透明度，默认0
        titleButton.layer.shadowRadius = 1                                  //阴影半径，默认3
        titleButton.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    
}
