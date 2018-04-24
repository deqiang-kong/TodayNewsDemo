//
//  AddCategoryCell.swift
//  TodayNewsDemo
//
//  我的频道按钮

import UIKit


protocol AddCategoryCellDelagate: class {
    func deleteCategoryButtonClicked(of cell: AddCategoryCell)
    
    func channelClicked(of cell: AddCategoryCell)
}

class AddCategoryCell: UICollectionViewCell, RegisterCellOrNib {
    
    public static let noEditType = 0
    
    weak var delegate: AddCategoryCellDelagate?
    var type = 0
    var isEdit = false {
        didSet {
            if self.type != AddCategoryCell.noEditType{
                deleteCategoryButton.isHidden = !isEdit
            }else{
                deleteCategoryButton.isHidden = true
            }
            
        }
    }
    
    @IBOutlet weak var titleButton: UIButton!
    
    @IBOutlet weak var deleteCategoryButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    @IBAction func channelClicked(_ sender: UIButton) {
        delegate?.channelClicked(of: self)
    }
    
    
    @IBAction func deleteCategoryButtonClicked(_ sender: UIButton) {
        delegate?.deleteCategoryButtonClicked(of: self)
    }
    
    
    func setTypeColor(type : Int){
        self.type = type
        if self.type == AddCategoryCell.noEditType{
            titleButton.setTitleColor(UIColor.red, for: .normal)
        }else{
            titleButton.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
}
