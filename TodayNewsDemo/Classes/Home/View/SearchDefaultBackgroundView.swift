//
//  SearchDefaultBackgroundView.swift
//  TodayNews-Swift
//
//

import UIKit

class SearchDefaultBackgroundView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class func defaultBackgroundView() -> SearchDefaultBackgroundView {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.last as! SearchDefaultBackgroundView
    }

}
