//
//  AllConcernsCell.swift
//  TodayNews
//
//

import UIKit
import Kingfisher
import IBAnimatable

class AllConcernsCell: UITableViewCell, RegisterCellOrNib {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var concernNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var weitoutiao: WeiTouTiao? {
        didSet{
    
        }
    }
    
    var myConcern: MyConcern? {
        didSet {
            iconImageView.kf.setImage(with: URL(string: (myConcern?.icon!)!))
            concernNameLabel.text = myConcern?.name!
            descriptionLabel.text = myConcern?.description!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
