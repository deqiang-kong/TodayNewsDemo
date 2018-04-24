//
//  ThumbCollectionViewCell.swift
//  TodayNews
//
//  缩略图展示

import UIKit
import Kingfisher

class ThumbCollectionViewCell: UICollectionViewCell, RegisterCellOrNib {
    
    @IBOutlet weak var galleryCountLabel: UILabel!
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.borderColor = UIColor(r: 240, g: 240, b: 240).cgColor
        thumbImageView.layer.borderWidth = 1
    }
    
    var thumbImageURL: String? {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: thumbImageURL!))
        }
    }
}
